//
//  PWModelManager.m
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWModelManager.h"
#import "PWRequestBuilder.h"
#import "PWRequestHolder.h"
#import "PWModelCacher.h"

@interface NSArray (Extension)

- (BOOL)containsTask:(NSURLSessionTask *)task;
- (PWRequestHolder *)holderForTask:(NSURLSessionTask *)task;
- (BOOL)allTasksCompleted;

@end

@implementation NSArray (Extension)

- (BOOL)containsTask:(NSURLSessionTask *)task
{
	BOOL result = NO;
	
	for (PWRequestHolder *holder in self)
	{
		if (holder.task == task)
		{
			result = YES;
			break;
		}
	}
	
	return result;
}

- (PWRequestHolder *)holderForTask:(NSURLSessionTask *)task
{
	PWRequestHolder *result = nil;
	
	for (PWRequestHolder *holder in self)
	{
		if (holder.task == task)
		{
			result = holder;
			break;
		}
	}
	
	return result;
}

- (BOOL)allTasksCompleted
{
	BOOL result = YES;
	
	for (PWRequestHolder *holder in self)
	{
		if (!holder.completed)
		{
			result = NO;
			break;
		}
	}
	
	return result;
}

@end

NSString *const kPWTokenKey = @"PWTokenKey";

@interface PWModelManager () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSArray<PWRestaurant *> *cachedRestaurants;
@property (nonatomic, strong) PWUser *user;
@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) PWRestaurant *currentRestaurant;

@property (nonatomic, strong) NSArray<PWRequestHolder *> *getNearItemsHolders;
@property (nonatomic, copy) void (^getNearItemsCompletion)(NSArray<PWRestaurant *> *nearRestaurant,
			NSArray<PWRestaurantShare *> *nearShares,
			NSArray<PWPresentProduct *> *nearPresents, NSError *error);

@property (nonatomic, strong) NSArray<PWRequestHolder *> *getActiveSharesHolders;
@property (nonatomic, copy) void (^getActiveSharesCompletion)
			(PWPresentProduct *firstPresent, NSArray *shares,
			NSArray *presentByBonuses, NSError *error);

@property (nonatomic, strong) PWRequestHolder *getBestOfDayHolder;
@property (nonatomic, strong) NSMutableArray<PWRequestHolder *> *getMenuInfoHolders;
@property (nonatomic, copy) void (^getMenuInfoCompletion)(NSArray<PWProduct *> *bestOfDay,
			NSDictionary<NSString *, NSArray<PWProduct *> *> *, NSError *error);

@property (nonatomic, strong) PWModelCacher *cacher;

@end

@implementation PWModelManager

+ (PWModelManager *)sharedManager
{
	static PWModelManager *sharedManager = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken,
	^{
		sharedManager = [PWModelManager new];
	});
	
	return sharedManager;
}

- (PWModelCacher *)cacher
{
	if (nil == _cacher)
	{
		_cacher = [PWModelCacher new];
	}
	
	return _cacher;
}

- (PWUser *)user
{
	if (nil == _user)
	{
		_user = [PWUser new];
	}
	
	return _user;
}

- (NSString *)authToken
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:kPWTokenKey];
}

- (PWUser *)registeredUser
{
	return self.user;
}

- (NSURLSession *)session
{
	if (nil == _session)
	{
		_session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration
					defaultSessionConfiguration] delegate:self delegateQueue:nil];
	}
	
	return _session;
}

- (NSError *)errorFromError:(NSError *)error response:(NSHTTPURLResponse *)response
{
	NSError *result = error;
	if (nil == error && 200 != response.statusCode)
	{
		result = [NSError errorWithDomain:@"API" code:response.statusCode userInfo:nil];
	}
	
	return result;
}

- (void)autentificateWithCompletion:(void (^)(NSString *token, NSError *error))completion
{
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:[PWRequestBuilder authRequest]
				completionHandler:
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		error = [self errorFromError:error response:(NSHTTPURLResponse *)response];
		NSString *token = nil;
		if (nil == error)
		{
			NSDictionary *jsonBody = [NSJSONSerialization
						JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
			if ([jsonBody[@"device"] isKindOfClass:[NSDictionary class]])
			{
				NSDictionary *deviceInfo = jsonBody[@"device"];
				token = deviceInfo[@"access_token"];
			}
		}
		dispatch_async(dispatch_get_main_queue(),
		^{
			if (nil != completion)
			{
				completion(token, error);
			}
		});
	}];
	[task resume];
}

- (void)getUserInfoWithCompletion:(void (^)(PWUser *user, NSError *error))completion
{
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:[PWRequestBuilder getUserRequest]
				completionHandler:
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		error = [self errorFromError:error response:(NSHTTPURLResponse *)response];
		PWUser *user = [self user];
		if (nil == error)
		{
			NSDictionary *jsonBody = [NSJSONSerialization
						JSONObjectWithData:data
						options:NSJSONReadingMutableContainers error:NULL];
			[user updateWithJsonInfo:jsonBody];
		}
		dispatch_async(dispatch_get_main_queue(),
		^{
			if (nil != completion)
			{
				completion(user, error);
			}
		});
	}];
	[task resume];
}

- (void)registerUserWithEmail:(NSString *)email password:(NSString *)password
			completion:(void (^)(NSError *))completion
{
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder signUpRequestWithProvider:@"email" email:email
				password:password profile:nil] completionHandler:
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		error = [self errorFromError:error response:(NSHTTPURLResponse *)response];
		dispatch_async(dispatch_get_main_queue(),
		^{
			if (nil != completion)
			{
				completion(error);
			}
		});
	}];
	[task resume];
}

- (void)signInWithEmail:(NSString *)email password:(NSString *)password
			completion:(void (^)(NSError *))completion
{
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder signInRequestWithProvider:@"email" email:email
				password:password profile:nil] completionHandler:
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		error = [self errorFromError:error response:(NSHTTPURLResponse *)response];
		dispatch_async(dispatch_get_main_queue(),
		^{
			if (nil != completion)
			{
				completion(error);
			}
		});
	}];
	[task resume];
}

- (void)signUpWithProvider:(NSString *)provider profile:(PWSocialProfile *)profile
			completion:(void (^)(NSError *))completion
{
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder signUpRequestWithProvider:provider email:nil
				password:nil profile:profile] completionHandler:
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		error = [self errorFromError:error response:(NSHTTPURLResponse *)response];
		dispatch_async(dispatch_get_main_queue(),
		^{
			if (nil != completion)
			{
				completion(error);
			}
		});
	}];
	[task resume];
}

- (void)updateUserAvatar:(UIImage *)avatar completion:(void (^)(NSError *))completion
{
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder putUserRequestWithUserName:nil password:nil
				currentPassword:nil email:nil avatar:avatar vkInfo:nil fbInfo:nil]
				completionHandler:
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		error = [self errorFromError:error response:(NSHTTPURLResponse *)response];
		dispatch_async(dispatch_get_main_queue(),
		^{
			if (nil != completion)
			{
				completion(error);
			}
		});
	}];
	[task resume];
}

- (void)updateUserPassword:(NSString *)password completion:(void (^)(NSError *))completion
{
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder putUserRequestWithUserName:nil password:password
				currentPassword:USER.password email:nil avatar:nil vkInfo:nil fbInfo:nil]
				completionHandler:
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		error = [self errorFromError:error response:(NSHTTPURLResponse *)response];
		dispatch_async(dispatch_get_main_queue(),
		^{
			if (nil != completion)
			{
				completion(error);
			}
		});
	}];
	[task resume];
}

- (void)getRestaurantsWithCount:(NSUInteger)count offset:(NSUInteger)offset
			completion:(void (^)(NSArray<PWRestaurant *> *, NSError *error))completion
{
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder getPlacesRequestForCategory:nil uuids:nil
				exceptionPlaceId:nil page:count count:offset]
				completionHandler:
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		error = [self errorFromError:error response:(NSHTTPURLResponse *)response];
		NSArray *restaurantsFound = nil;
		if (nil == error)
		{
			NSMutableArray *restaurants = [NSMutableArray array];
			NSArray *jsonBody = [NSJSONSerialization
						JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
			for (id jsonObject in jsonBody)
			{
				[restaurants addObject:[[PWRestaurant alloc] initWithJSONInfo:jsonObject]];
			}
			restaurantsFound = restaurants;
		}

		dispatch_async(dispatch_get_main_queue(),
		^{
			[self.cacher cacheRestaurants:restaurantsFound];
			if (nil != completion)
			{
				completion(restaurantsFound, error);
			}
		});
	}];
	[task resume];
}

- (void)getSharesWithCount:(NSUInteger)count offset:(NSUInteger)offset
			completion:(void (^)(NSArray<PWRestaurantShare *> *, NSError *error))completion
{
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder getSharesRequestWithPage:offset count:count exceptionPlaceId:nil
				latitude:nil longitude:nil] completionHandler:
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		error = [self errorFromError:error response:(NSHTTPURLResponse *)response];
		NSArray *sharesFound = nil;
		if (nil == error)
		{
			NSMutableArray *shares = [NSMutableArray array];
			NSArray *jsonBody = [NSJSONSerialization
						JSONObjectWithData:data options:NSJSONReadingMutableContainers
						error:NULL];
			for (id jsonObject in jsonBody)
			{
				[shares addObject:[[PWRestaurantShare alloc] initWithJSONInfo:jsonObject]];
			}
			sharesFound = shares;
		}
		dispatch_async(dispatch_get_main_queue(),
		^{
			[self.cacher cacheShares:sharesFound];
			if (nil != completion)
			{
				completion(sharesFound, error);
			}
		});
	}];
	[task resume];
}

- (void)getPresentsWithCount:(NSUInteger)count offset:(NSUInteger)offset
			completion:(void (^)(NSArray<PWPresentProduct *> *, NSError *error))completion
{
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder getPresentsRequestWithPage:offset count:count exceptionPlaceId:nil
				latitude:nil longitude:nil] completionHandler:
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		error = [self errorFromError:error response:(NSHTTPURLResponse *)response];
		NSArray *presentsFound = nil;
		if (nil == error)
		{
			NSMutableArray *presents = [NSMutableArray array];
			NSArray *jsonBody = [NSJSONSerialization
						JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
			for (id jsonObject in jsonBody)
			{
				[presents addObject:[[PWPresentProduct alloc] initWithJSONInfo:jsonObject]];
			}
			presentsFound = presents;
		}
		dispatch_async(dispatch_get_main_queue(),
		^{
			[self.cacher cachePresents:presentsFound];
			if (nil != completion)
			{
				completion(presentsFound, error);
			}
		});
	}];
	[task resume];
}

- (void)getPurchasesRestaurantsForUser:(PWUser *)user withCount:(NSUInteger)count
			offset:(NSUInteger)offset completion:
			(void (^)(NSArray<PWRestaurant *> *, NSError *error))completion
{
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder getCardsRequest] completionHandler:
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		error = [self errorFromError:error response:(NSHTTPURLResponse *)response];
		NSArray *restaurantsFound = nil;
		if (nil == error)
		{
			NSMutableArray *restaurants = [NSMutableArray array];
			NSArray *jsonBody = [NSJSONSerialization
						JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
			for (id jsonObject in jsonBody)
			{
				[restaurants addObject:[[PWRestaurant alloc] initWithJSONInfo:jsonObject]];
			}
			restaurantsFound = restaurants;
		}
		
		dispatch_async(dispatch_get_main_queue(),
		^{
			[self.cacher cachePurchaseRestaurants:restaurantsFound];
			if (nil != completion)
			{
				completion(restaurantsFound, error);
			}
		});
	}];
	[task resume];
}

- (void)getPurchasesForUser:(PWUser *)user restaurant:(PWRestaurant *)restaurant
			withCount:(NSUInteger)count offset:(NSUInteger)offset completion:
			(void (^)(NSArray<PWPurchase *> *, NSError *error))completion
{
	self.currentRestaurant = restaurant;
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder getPurchasesRequestForPlace:restaurant.identifier.integerValue
				page:offset count:count] completionHandler:
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		error = [self errorFromError:error response:(NSHTTPURLResponse *)response];
		NSArray *purchasesFound = nil;
		if (nil == error)
		{
			NSMutableArray *purchases = [NSMutableArray array];
			NSArray *jsonBody = [NSJSONSerialization JSONObjectWithData:data
						options:NSJSONReadingMutableContainers error:NULL];
			for (id jsonObject in jsonBody)
			{
				[purchases addObject:[[PWPurchase alloc] initWithJSONInfo:jsonObject]];
			}
			purchasesFound = purchases;
		}
		
		dispatch_async(dispatch_get_main_queue(),
		^{
			[self.cacher cachePurchases:purchasesFound
						forRestaurant:self.currentRestaurant];
			if (nil != completion)
			{
				completion(purchasesFound, error);
			}
		});
	}];
	[task resume];
}

- (void)getRestaurantForBeacons:(NSArray<NSString *> *)beacons
			completion:(void (^)(PWRestaurant *restaurant, NSError *error))completion
{
#if 0
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder getPlacesRequestForCategory:nil
				uuids:beacons exceptionPlaceId:nil page:0 count:1]
				completionHandler:
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		error = [self errorFromError:error response:(NSHTTPURLResponse *)response];
		PWRestaurant *restaurantFound = nil;
		if (nil == error)
		{
			NSMutableArray *restaurants = [NSMutableArray array];
			NSArray *jsonBody = [NSJSONSerialization
						JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
			for (id jsonObject in jsonBody)
			{
				[restaurants addObject:[[PWRestaurant alloc] initWithJSONInfo:jsonObject]];
			}
			restaurantFound = restaurants.firstObject;
		}

		dispatch_async(dispatch_get_main_queue(),
		^{
			[self.cacher cacheRestaurants:@[restaurantFound]];
			if (nil != completion)
			{
				completion(restaurantFound, error);
			}
		});
	}];
	[task resume];
#else
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
				(int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
	^{
		if (nil != completion)
		{
			if (self.cacher.currentRestaurant != self.cacher.restaurants.firstObject)
			{
				self.cacher.currentRestaurant = self.cacher.restaurants.firstObject;
				completion(self.cacher.currentRestaurant, nil);
			}
		}
	});
#endif
}

- (void)getFirstPresentsInfoForUser:(PWUser *)user restaurant:(PWRestaurant *)restaurant
			completion:(void (^)(PWPresentProduct *firstPresent, NSArray *shares,
			NSArray *presentByBonuses, NSError *error))completion
{
	self.getActiveSharesCompletion = completion;
	self.currentRestaurant = restaurant;
	
	NSURLSessionDataTask *firstPresentTask = [self.session dataTaskWithRequest:
				[PWRequestBuilder getFirstPresentRequestForPlace:restaurant.identifier.integerValue]];
	PWRequestHolder *firstPresentHolder = [[PWRequestHolder alloc] initWithTask:firstPresentTask];
	
	NSURLSessionDataTask *sharesTask = [self.session dataTaskWithRequest:
				[PWRequestBuilder getSharesRequestForPlace:restaurant.identifier.integerValue
				page:0 count:6 exceptionPlaceId:nil latitude:nil longitude:nil]];
	PWRequestHolder *sharesHolder = [[PWRequestHolder alloc] initWithTask:sharesTask];
	
	NSURLSessionDataTask *byBonusesTask = [self.session dataTaskWithRequest:
				[PWRequestBuilder getPresentsRequestForPlace:restaurant.identifier.integerValue
				page:0 count:6 exceptionPlaceId:nil latitude:nil longitude:nil]];
	PWRequestHolder *byBonusesHolder = [[PWRequestHolder alloc] initWithTask:byBonusesTask];
	
	self.getActiveSharesHolders = @[firstPresentHolder, sharesHolder, byBonusesHolder];
	[firstPresentTask resume];
	[sharesTask resume];
	[byBonusesTask resume];
}

- (void)getNearItemsWithCount:(NSUInteger)count
			location:(CLLocation *)location
			completion:(void (^)(NSArray<PWRestaurant *> *nearRestaurant,
			NSArray<PWRestaurantShare *> *nearShares,
			NSArray<PWPresentProduct *> *nearPresents, NSError *error))completion
{
	self.getNearItemsCompletion = completion;
	
	NSNumber *latitude = nil;
	NSNumber *longitude = nil;
	
	if (nil != location)
	{
		latitude = @(location.coordinate.latitude);
		longitude = @(location.coordinate.longitude);
	}
	
	NSURLSessionDataTask *presentsTask = [self.session dataTaskWithRequest:
				[PWRequestBuilder getPresentsRequestWithPage:0 count:6
				exceptionPlaceId:self.currentRestaurant.identifier latitude:latitude longitude:longitude]];
	PWRequestHolder *presentsHolder = [[PWRequestHolder alloc] initWithTask:presentsTask];
	
	NSURLSessionDataTask *sharesTask = [self.session dataTaskWithRequest:
				[PWRequestBuilder getSharesRequestWithPage:0 count:6 exceptionPlaceId:self.currentRestaurant.identifier
				latitude:latitude longitude:longitude]];
	PWRequestHolder *sharesHolder = [[PWRequestHolder alloc] initWithTask:sharesTask];
	
	NSURLSessionDataTask *restaurantsTask = [self.session dataTaskWithRequest:
				[PWRequestBuilder getPlacesRequestForCategory:nil uuids:nil exceptionPlaceId:nil page:0 count:6]];
	PWRequestHolder *restaurantsHolder = [[PWRequestHolder alloc] initWithTask:restaurantsTask];
	
	self.getNearItemsHolders = @[presentsHolder, sharesHolder, restaurantsHolder];
	[presentsTask resume];
	[sharesTask resume];
	[restaurantsTask resume];
}

- (void)getRecomendedProductsInfoForUser:(PWUser *)user restaurant:(PWRestaurant *)restaurant
			completion:(void (^)(NSArray<PWProduct *> *products, NSError *error))completion
{
	self.currentRestaurant = restaurant;
	NSURLSessionDataTask *getRecomendedTask = [self.session dataTaskWithRequest:
				[PWRequestBuilder getProductsRequestForPlace:self.currentRestaurant.identifier.integerValue
				dayItem:nil recomended:@(YES) page:0 count:6] completionHandler:
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		error = [self errorFromError:error response:(NSHTTPURLResponse *)response];
		NSMutableArray *recomendedProducts = nil;
		if (nil == error)
		{
			NSArray *jsonBody = [NSJSONSerialization JSONObjectWithData:data
						options:NSJSONReadingMutableContainers error:NULL];
			recomendedProducts = [NSMutableArray array];
			for (NSDictionary *json in jsonBody)
			{
				[recomendedProducts addObject:[[PWProduct alloc] initWithJSONInfo:json]];
			}
		}
		
		dispatch_async(dispatch_get_main_queue(),
		^{
			if (nil != completion)
			{
				completion(recomendedProducts, error);
			}
		});
	}];
	[getRecomendedTask resume];
}

- (void)getRootMenuInfoForUser:(PWUser *)user restaurant:(PWRestaurant *)restaurant
			completion:(void (^)(NSArray<PWProduct *> *bestOfDay, NSDictionary<NSString *, NSArray<PWProduct *> *> *, NSError *error))completion
{
	self.getMenuInfoCompletion = completion;
	self.currentRestaurant = restaurant;
	NSURLSessionDataTask *getCategoriesTask = [self.session dataTaskWithRequest:
				[PWRequestBuilder getMenuCategoriesRequestForPlace:restaurant.identifier.integerValue]
				completionHandler:
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		error = [self errorFromError:error response:(NSHTTPURLResponse *)response];
		
		NSArray *jsonBody = [NSJSONSerialization JSONObjectWithData:data
					options:NSJSONReadingMutableContainers error:NULL];
		
		self.getMenuInfoHolders = [NSMutableArray array];
		for (NSDictionary *categoryInfo in jsonBody)
		{
			NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
						[PWRequestBuilder getProductsRequestForCategoryId:
						[categoryInfo[@"id"] integerValue] page:0 count:6]];
			PWGetCategoryRequestHolder *holder = [[PWGetCategoryRequestHolder alloc]
						initWithTask:task title:categoryInfo[@"name"]];
			
			[self.getMenuInfoHolders addObject:holder];
			[task resume];
		}
		
		NSURLSessionDataTask *getBestOfDayTask = [self.session dataTaskWithRequest:
					[PWRequestBuilder getProductsRequestForPlace:self.currentRestaurant.identifier.integerValue
					dayItem:@(YES) recomended:nil page:0 count:6]];
		self.getBestOfDayHolder = [[PWRequestHolder alloc] initWithTask:getBestOfDayTask];
		[getBestOfDayTask resume];
	}];
	[getCategoriesTask resume];
}

- (void)getCommentsInfoForRestaurant:(PWRestaurant *)restaurant page:(NSUInteger)page completion:(void (^)
			(NSArray<PWRestaurantReview *> *, NSError *error))completion
{
	self.currentRestaurant = restaurant;
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder getReviewsRequestForPlace:restaurant.identifier.
				integerValue page:page count:10] completionHandler:
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		error = [self errorFromError:error response:(NSHTTPURLResponse *)response];
		NSMutableArray *reviews = nil;
		if (nil == error)
		{
			NSArray *jsonBody = [NSJSONSerialization JSONObjectWithData:data
						options:NSJSONReadingMutableContainers error:NULL];
			reviews = [NSMutableArray array];
			for (NSDictionary *json in jsonBody)
			{
				[reviews addObject:[[PWRestaurantReview alloc] initWithJSONInfo:json]];
			}
		}
		
		dispatch_async(dispatch_get_main_queue(),
		^{
			if (nil != completion)
			{
				completion(reviews, error);
			}
		});
	}];
	[task resume];
}

- (void)sendReview:(PWRestaurantReview *)review completion:(void (^)(NSError *error))completion
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
				(int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
	^{
		if (nil != completion)
		{
			completion(nil);
		}
	});
}

- (void)getAboutInfoForRestaurant:(PWRestaurant *)restaurant completion:(void (^)(PWRestaurantAboutInfo *, NSError *error))completion
{
	self.currentRestaurant = restaurant;
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder restaurantRequestWithId:restaurant.identifier.integerValue] completionHandler:
	^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
	{
		error = [self errorFromError:error response:(NSHTTPURLResponse *)response];
		PWRestaurant *restaurant = nil;
		if (nil == error)
		{
			NSDictionary *jsonBody = [NSJSONSerialization JSONObjectWithData:data
						options:NSJSONReadingMutableContainers error:NULL];
			restaurant = [[PWRestaurant alloc] initWithJSONInfo:jsonBody];
		}
		
		dispatch_async(dispatch_get_main_queue(),
		^{
			if (nil != completion)
			{
				completion(restaurant.aboutInfo, error);
			}
		});
	}];
	[task resume];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
			didReceiveData:(NSData *)data
{
	PWRequestHolder *holder = nil;
	if ([self.getNearItemsHolders containsTask:dataTask])
	{
		holder = [self.getNearItemsHolders holderForTask:dataTask];
	}
	else if ([self.getActiveSharesHolders containsTask:dataTask])
	{
		holder = [self.getActiveSharesHolders holderForTask:dataTask];
	}
	else if (dataTask == self.getBestOfDayHolder.task)
	{
		holder = self.getBestOfDayHolder;
	}
	else if ([self.getMenuInfoHolders containsTask:dataTask])
	{
		holder = [self.getMenuInfoHolders holderForTask:dataTask];
	}
	
	[holder processData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
			didReceiveResponse:(NSURLResponse *)response
			completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
	PWRequestHolder *holder = nil;
	if ([self.getNearItemsHolders containsTask:dataTask])
	{
		holder = [self.getNearItemsHolders holderForTask:dataTask];
	}
	else if ([self.getActiveSharesHolders containsTask:dataTask])
	{
		holder = [self.getActiveSharesHolders holderForTask:dataTask];
	}
	else if (dataTask == self.getBestOfDayHolder.task)
	{
		holder = self.getBestOfDayHolder;
	}
	else if ([self.getMenuInfoHolders containsTask:dataTask])
	{
		holder = [self.getMenuInfoHolders holderForTask:dataTask];
	}
	
	[holder processResponse:(NSHTTPURLResponse *)response];
	
	completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
	if (nil == error && 200 != ((NSHTTPURLResponse *)task.response).statusCode)
	{
		error = [NSError errorWithDomain:@"API" code:((NSHTTPURLResponse *)task.response).statusCode userInfo:nil];
	}

	if ([self.getNearItemsHolders containsTask:task])
	{
		[self.getNearItemsHolders holderForTask:task].completed = YES;
		
		if ([self.getNearItemsHolders allTasksCompleted])
		{
			NSArray *restaurantsFound = nil;
			NSArray *presentsFound = nil;
			NSArray *sharesFound = nil;
			if (nil == error)
			{
				NSMutableArray *presents = [NSMutableArray array];
				NSArray *jsonBody = [NSJSONSerialization
							JSONObjectWithData:self.getNearItemsHolders[0].data options:NSJSONReadingMutableContainers error:NULL];
				for (id jsonObject in jsonBody)
				{
					[presents addObject:[[PWPresentProduct alloc] initWithJSONInfo:jsonObject]];
				}
				presentsFound = presents;
			
				NSMutableArray *shares = [NSMutableArray array];
				jsonBody = [NSJSONSerialization
							JSONObjectWithData:self.getNearItemsHolders[1].data options:NSJSONReadingMutableContainers error:NULL];
				for (id jsonObject in jsonBody)
				{
					[shares addObject:[[PWRestaurantShare alloc] initWithJSONInfo:jsonObject]];
				}
				sharesFound = shares;
				NSMutableArray *restaurants = [NSMutableArray array];
				jsonBody = [NSJSONSerialization
							JSONObjectWithData:self.getNearItemsHolders[2].data options:NSJSONReadingMutableContainers error:NULL];
				for (id jsonObject in jsonBody)
				{
					[restaurants addObject:[[PWRestaurant alloc] initWithJSONInfo:jsonObject]];
				}
				restaurantsFound = restaurants;
			}
			dispatch_async(dispatch_get_main_queue(),
			^{
				[self.cacher cacheRestaurants:restaurantsFound];
				[self.cacher cachePresents:presentsFound];
				[self.cacher cacheShares:sharesFound];
				self.getNearItemsCompletion(restaurantsFound, sharesFound, presentsFound, error);
			});
		}
	}
	else if ([self.getActiveSharesHolders containsTask:task])
	{
		[self.getActiveSharesHolders holderForTask:task].completed = YES;
		if ([self.getActiveSharesHolders allTasksCompleted])
		{
			PWPresentProduct *firstPresent = nil;
			NSArray *bonusesFound = nil;
			NSArray *sharesFound = nil;
			if (nil == error)
			{
				NSMutableArray *bonuses = [NSMutableArray array];
				NSArray *jsonBody = [NSJSONSerialization
							JSONObjectWithData:self.getActiveSharesHolders[2].data options:NSJSONReadingMutableContainers error:NULL];
				for (id jsonObject in jsonBody)
				{
					[bonuses addObject:[[PWPresentProduct alloc] initWithJSONInfo:jsonObject]];
				}
				bonusesFound = bonuses;
			
				NSMutableArray *shares = [NSMutableArray array];
				jsonBody = [NSJSONSerialization
							JSONObjectWithData:self.getActiveSharesHolders[1].data options:NSJSONReadingMutableContainers error:NULL];
				for (id jsonObject in jsonBody)
				{
					[shares addObject:[[PWRestaurantShare alloc] initWithJSONInfo:jsonObject]];
				}
				sharesFound = shares;
				firstPresent = [[PWPresentProduct alloc] initWithJSONInfo:[NSJSONSerialization
							JSONObjectWithData:self.getActiveSharesHolders[0].data
							options:NSJSONReadingMutableContainers error:NULL]];
			}
			dispatch_async(dispatch_get_main_queue(),
			^{
				[self.cacher cacheFirstPresent:firstPresent forRestaurant:self.currentRestaurant];
				[self.cacher cacheShares:sharesFound forRestaurant:self.currentRestaurant];
				[self.cacher cachePresents:bonusesFound forRestaurant:self.currentRestaurant];
				self.getActiveSharesCompletion(firstPresent, sharesFound, bonusesFound, error);
			});
		}
	}
	else if (task == self.getBestOfDayHolder.task || [self.getMenuInfoHolders containsTask:task])
	{
		if (task == self.getBestOfDayHolder.task)
		{
			self.getBestOfDayHolder.completed = YES;
		}
		else
		{
			[self.getMenuInfoHolders holderForTask:task].completed = YES;
		}
		
		if (self.getBestOfDayHolder.completed && [self.getMenuInfoHolders allTasksCompleted])
		{
			NSMutableArray *bestOfDayProducts = nil;
			NSMutableDictionary *categoryProductsInfo = nil;
			
			if (nil == error)
			{
				bestOfDayProducts = [NSMutableArray array];
				categoryProductsInfo = [NSMutableDictionary dictionary];
				NSArray *bestOfDayJsonBody = [NSJSONSerialization
							JSONObjectWithData:self.getBestOfDayHolder.data
							options:NSJSONReadingMutableContainers error:NULL];
				
				for (NSDictionary *json in bestOfDayJsonBody)
				{
					[bestOfDayProducts addObject:[[PWProduct alloc] initWithJSONInfo:json]];
				}
				
				for (PWGetCategoryRequestHolder *holder in self.getMenuInfoHolders)
				{
					NSArray *categoryJsonBody = [NSJSONSerialization
								JSONObjectWithData:holder.data
								options:NSJSONReadingMutableContainers error:NULL];
					NSMutableArray *categoryProducts = [NSMutableArray array];
					
					for (NSDictionary *json in categoryJsonBody)
					{
						[categoryProducts addObject:[[PWProduct alloc] initWithJSONInfo:json]];
					}
					categoryProductsInfo[holder.title] = categoryProducts;
				}
			}
			
			dispatch_async(dispatch_get_main_queue(),
			^{
				self.getMenuInfoCompletion(bestOfDayProducts, categoryProductsInfo, error);
			});
		}
	}
}

@end
