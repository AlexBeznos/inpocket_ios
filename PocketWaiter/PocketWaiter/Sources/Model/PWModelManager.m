//
//  PWModelManager.m
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWModelManager.h"
#import "PWStubModel.h"
#import "PWRequestBuilder.h"
#import "PWRequestHolder.h"
#import "PWModelCacher.h"

NSString *const kPWTokenKey = @"PWTokenKey";

@interface PWModelManager () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSArray<PWRestaurant *> *cachedRestaurants;
@property (nonatomic, strong) PWUser *user;
@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) PWRequestHolder *authHolder;
@property (nonatomic, copy) void (^authCompletion)(NSString *token, NSError *error);

@property (nonatomic, strong) PWRequestHolder *getUserHolder;
@property (nonatomic, copy) void (^getUserCompletion)(PWUser *user, NSError *error);

@property (nonatomic, strong) PWRequestHolder *signUpUserHolder;
@property (nonatomic, copy) void (^signUpUserCompletion)(NSError *error);

@property (nonatomic, strong) PWRequestHolder *signUpSocialHolder;
@property (nonatomic, copy) void (^signUpSocialCompletion)(NSError *error);

@property (nonatomic, strong) PWRequestHolder *signInUserHolder;
@property (nonatomic, copy) void (^signInUserCompletion)(NSError *error);

@property (nonatomic, strong) PWRequestHolder *updateUserInfoHolder;
@property (nonatomic, copy) void (^updateUserInfoCompletion)(NSError *error);

@property (nonatomic, strong) PWRequestHolder *getRestaurantsHolder;
@property (nonatomic, copy) void (^getRestaurantsCompletion)
			(NSArray<PWRestaurant *> *, NSError *error);

@property (nonatomic, strong) PWRequestHolder *getSharesHolder;
@property (nonatomic, copy) void (^getSharesCompletion)
			(NSArray<PWRestaurantShare *> *, NSError *error);

@property (nonatomic, strong) PWRequestHolder *getPresentsHolder;
@property (nonatomic, copy) void (^getPresentsCompletion)
			(NSArray<PWPresentProduct *> *, NSError *error);

@property (nonatomic, strong) PWRequestHolder *getPurchaseRestaurantsHolder;
@property (nonatomic, copy) void (^getPurchaseRestaurantsCompletion)
			(NSArray<PWRestaurant *> *, NSError *error);

@property (nonatomic, strong) PWRequestHolder *getPurchasesHolder;
@property (nonatomic, copy) void (^getPurchasesCompletion)
			(NSArray<PWPurchase *> *, NSError *error);
@property (nonatomic, strong) PWRestaurant *currentRestaurant;

@property (nonatomic, strong) NSArray<PWRequestHolder *> *getNearItemsHolders;
@property (nonatomic, copy) void (^getNearItemsCompletion)(NSArray<PWRestaurant *> *nearRestaurant,
			NSArray<PWRestaurantShare *> *nearShares,
			NSArray<PWPresentProduct *> *nearPresents, NSError *error);

@property (nonatomic, strong) NSArray<PWRequestHolder *> *getActiveSharesHolders;
@property (nonatomic, copy) void (^getActiveSharesCompletion)
			(PWPresentProduct *firstPresent, NSArray *shares,
			NSArray *presentByBonuses, NSError *error);

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

- (void)autentificateWithCompletion:(void (^)(NSString *token, NSError *error))completion
{
	self.authCompletion = completion;
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:[PWRequestBuilder authRequest]];
	self.authHolder = [[PWRequestHolder alloc] initWithTask:task];
	[task resume];
}

- (void)getUserInfoWithCompletion:(void (^)(PWUser *user, NSError *error))completion
{
	self.getUserCompletion = completion;
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:[PWRequestBuilder getUserRequest]];
	self.getUserHolder = [[PWRequestHolder alloc] initWithTask:task];
	[task resume];
}

- (void)registerUserWithEmail:(NSString *)email password:(NSString *)password
			completion:(void (^)(NSError *))completion
{
	self.signUpUserCompletion = completion;
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder signUpRequestWithProvider:@"email" email:email
				password:password profile:nil]];
	self.signUpUserHolder = [[PWRequestHolder alloc] initWithTask:task];
	[task resume];
}

- (void)signInWithEmail:(NSString *)email password:(NSString *)password
			completion:(void (^)(NSError *))completion
{
	self.signInUserCompletion = completion;
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder signInRequestWithProvider:@"email" email:email
				password:password profile:nil]];
	self.signInUserHolder = [[PWRequestHolder alloc] initWithTask:task];
	[task resume];
}

- (void)signUpWithProvider:(NSString *)provider profile:(PWSocialProfile *)profile
			completion:(void (^)(NSError *))completion
{
	self.signUpSocialCompletion = completion;
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder signUpRequestWithProvider:provider email:nil
				password:nil profile:profile]];
	self.signUpSocialHolder = [[PWRequestHolder alloc] initWithTask:task];
	[task resume];
}

- (void)updateUserWithCompletion:(void (^)(NSError *))completion
{
	self.updateUserInfoCompletion = completion;
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder putUserRequestWithUser:self.user]];
	self.updateUserInfoHolder = [[PWRequestHolder alloc] initWithTask:task];
	[task resume];
}

- (void)getRestaurantsWithCount:(NSUInteger)count offset:(NSUInteger)offset
			completion:(void (^)(NSArray<PWRestaurant *> *, NSError *error))completion
{
	self.getRestaurantsCompletion = completion;
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder getPlacesRequestForCategory:nil exceptionPlaceId:nil]];
	self.getRestaurantsHolder = [[PWRequestHolder alloc] initWithTask:task];
	[task resume];
}

- (void)getSharesWithCount:(NSUInteger)count offset:(NSUInteger)offset
			completion:(void (^)(NSArray<PWRestaurantShare *> *, NSError *error))completion
{
	self.getSharesCompletion = completion;
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder getPresentsRequestWithPage:offset count:count exceptionPlaceId:nil
				latitude:nil longitude:nil]];
	self.getSharesHolder = [[PWRequestHolder alloc] initWithTask:task];
	[task resume];
}

- (void)getPresentsWithCount:(NSUInteger)count offset:(NSUInteger)offset
			completion:(void (^)(NSArray<PWPresentProduct *> *, NSError *error))completion
{
	self.getPresentsCompletion= completion;
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder getPresentsRequestWithPage:offset count:count exceptionPlaceId:nil
				latitude:nil longitude:nil]];
	self.getPresentsHolder = [[PWRequestHolder alloc] initWithTask:task];
	[task resume];
}

- (void)getPurchasesRestaurantsForUser:(PWUser *)user withCount:(NSUInteger)count
			offset:(NSUInteger)offset completion:
			(void (^)(NSArray<PWRestaurant *> *, NSError *error))completion
{
	self.getPurchaseRestaurantsCompletion = completion;
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder getCardsRequest]];
	self.getPurchaseRestaurantsHolder = [[PWRequestHolder alloc] initWithTask:task];
	[task resume];
}

- (void)getPurchasesForUser:(PWUser *)user restaurant:(PWRestaurant *)restaurant
			withCount:(NSUInteger)count
			offset:(NSUInteger)offset completion:
			(void (^)(NSArray<PWPurchase *> *, NSError *error))completion
{
	self.currentRestaurant = restaurant;
	self.getPurchasesCompletion = completion;
	NSURLSessionDataTask *task = [self.session dataTaskWithRequest:
				[PWRequestBuilder getPurchasesRequestForPlace:restaurant.identifier.integerValue
				page:offset count:count]];
	self.getPurchasesHolder = [[PWRequestHolder alloc] initWithTask:task];
	[task resume];
}

- (void)getRestaurantForBeacons:(NSArray<NSString *> *)beacons
			completion:(void (^)(PWRestaurant *restaurant, NSError *error))completion
{
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
			completion:(void (^)(NSArray<PWRestaurant *> *nearRestaurant,
			NSArray<PWRestaurantShare *> *nearShares,
			NSArray<PWPresentProduct *> *nearPresents, NSError *error))completion
{
	self.getNearItemsCompletion = completion;
	
	NSURLSessionDataTask *presentsTask = [self.session dataTaskWithRequest:
				[PWRequestBuilder getPresentsRequestWithPage:0 count:6
				exceptionPlaceId:nil latitude:nil longitude:nil]];
	PWRequestHolder *presentsHolder = [[PWRequestHolder alloc] initWithTask:presentsTask];
	
	NSURLSessionDataTask *sharesTask = [self.session dataTaskWithRequest:
				[PWRequestBuilder getPresentsRequestWithPage:0 count:6 exceptionPlaceId:nil
				latitude:nil longitude:nil]];
	PWRequestHolder *sharesHolder = [[PWRequestHolder alloc] initWithTask:sharesTask];
	
	NSURLSessionDataTask *restaurantsTask = [self.session dataTaskWithRequest:
				[PWRequestBuilder getPlacesRequestForCategory:nil exceptionPlaceId:nil]];
	PWRequestHolder *restaurantsHolder = [[PWRequestHolder alloc] initWithTask:restaurantsTask];
	
	self.getNearItemsHolders = @[presentsHolder, sharesHolder, restaurantsHolder];
	[presentsTask resume];
	[sharesTask resume];
	[restaurantsTask resume];
}

- (void)getRecomendedProductsInfoForUser:(PWUser *)user restaurant:(PWRestaurant *)restaurant
			completion:(void (^)(NSArray<PWProduct *> *products, NSError *error))completion
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
				(int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
	^{
		if (nil != completion)
		{
			completion(restaurant.products, nil);
		}
	});
}

- (void)getRootMenuInfoForUser:(PWUser *)user restaurant:(PWRestaurant *)restaurant
			completion:(void (^)(NSArray<PWProduct *> *bestOfDay, NSDictionary<NSString *, NSArray<PWProduct *> *> *, NSError *error))completion
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
				(int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
	^{
		if (nil != completion)
		{
			completion(restaurant.products, @{@"Паста" : restaurant.products,
						@"Кальян" : restaurant.products, @"Напитки" : restaurant.products,
						@"Первое" : restaurant.products}, nil);
		}
	});
}

- (void)getCommentsInfoForRestaurant:(PWRestaurant *)restaurant completion:(void (^)(BOOL allowComment, NSArray<PWRestaurantReview *> *, NSError *error))completion
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
				(int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
	^{
		if (nil != completion)
		{
			completion(YES, [self.cachedRestaurants.firstObject reviews], nil);
		}
	});
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
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
				(int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
	^{
		if (nil != completion)
		{
			completion(self.cachedRestaurants.firstObject.aboutInfo, nil);
		}
	});
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
			didReceiveData:(NSData *)data
{
	PWRequestHolder *holder = nil;
	if (dataTask == self.authHolder.task)
	{
		holder = self.authHolder;
	}
	else if (dataTask == self.getRestaurantsHolder.task)
	{
		holder = self.getRestaurantsHolder;
	}
	else if (dataTask == self.getNearItemsHolders.firstObject.task)
	{
		holder = self.getNearItemsHolders.firstObject;
	}
	else if (dataTask == self.getNearItemsHolders[1].task)
	{
		holder = self.getNearItemsHolders[1];
	}
	else if (dataTask == self.getNearItemsHolders[2].task)
	{
		holder = self.getNearItemsHolders[2];
	}
	else if (dataTask == self.getPresentsHolder.task)
	{
		holder = self.getPresentsHolder;
	}
	else if (dataTask == self.getSharesHolder.task)
	{
		holder = self.getSharesHolder;
	}
	else if (dataTask == self.getPurchaseRestaurantsHolder.task)
	{
		holder = self.getSharesHolder;
	}
	else if (dataTask == self.getPurchasesHolder.task)
	{
		holder = self.getPurchasesHolder;
	}
	else if (dataTask == self.getActiveSharesHolders.firstObject.task)
	{
		holder = self.getActiveSharesHolders.firstObject;
	}
	else if (dataTask == self.getActiveSharesHolders[1].task)
	{
		holder = self.getActiveSharesHolders[1];
	}
	else if (dataTask == self.getActiveSharesHolders[2].task)
	{
		holder = self.getActiveSharesHolders[2];
	}
	else if (dataTask == self.getUserHolder.task)
	{
		holder = self.getUserHolder;
	}
	else if (dataTask == self.signUpUserHolder.task)
	{
		holder = self.signUpUserHolder;
	}
	else if (dataTask == self.signInUserHolder.task)
	{
		holder = self.signInUserHolder;
	}
	else if (dataTask == self.signUpSocialHolder.task)
	{
		holder = self.signUpSocialHolder;
	}
	else if (dataTask == self.updateUserInfoHolder.task)
	{
		holder = self.updateUserInfoHolder;
	}
	
	[holder processData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
			didReceiveResponse:(NSURLResponse *)response
			completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
	PWRequestHolder *holder = nil;
	if (dataTask == self.authHolder.task)
	{
		holder = self.authHolder;
	}
	else if (dataTask == self.getRestaurantsHolder.task)
	{
		holder = self.getRestaurantsHolder;
	}
	else if (dataTask == self.getNearItemsHolders.firstObject.task)
	{
		holder = self.getNearItemsHolders.firstObject;
	}
	else if (dataTask == self.getNearItemsHolders[1].task)
	{
		holder = self.getNearItemsHolders[1];
	}
	else if (dataTask == self.getNearItemsHolders[2].task)
	{
		holder = self.getNearItemsHolders[2];
	}
	else if (dataTask == self.getPresentsHolder.task)
	{
		holder = self.getPresentsHolder;
	}
	else if (dataTask == self.getSharesHolder.task)
	{
		holder = self.getSharesHolder;
	}
	else if (dataTask == self.getPurchaseRestaurantsHolder.task)
	{
		holder = self.getSharesHolder;
	}
	else if (dataTask == self.getPurchasesHolder.task)
	{
		holder = self.getPurchasesHolder;
	}
	else if (dataTask == self.getActiveSharesHolders.firstObject.task)
	{
		holder = self.getActiveSharesHolders.firstObject;
	}
	else if (dataTask == self.getActiveSharesHolders[1].task)
	{
		holder = self.getActiveSharesHolders[1];
	}
	else if (dataTask == self.getActiveSharesHolders[2].task)
	{
		holder = self.getActiveSharesHolders[2];
	}
	else if (dataTask == self.getUserHolder.task)
	{
		holder = self.getUserHolder;
	}
	else if (dataTask == self.signUpUserHolder.task)
	{
		holder = self.signUpUserHolder;
	}
	else if (dataTask == self.signInUserHolder.task)
	{
		holder = self.signInUserHolder;
	}
	else if (dataTask == self.signUpSocialHolder.task)
	{
		holder = self.signUpSocialHolder;
	}
	else if (dataTask == self.updateUserInfoHolder.task)
	{
		holder = self.updateUserInfoHolder;
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

	if (task == self.authHolder.task)
	{
		NSString *token = nil;
		if (nil == error)
		{
			NSDictionary *jsonBody = [NSJSONSerialization
						JSONObjectWithData:self.authHolder.data options:NSJSONReadingMutableContainers error:NULL];
			if ([jsonBody[@"device"] isKindOfClass:[NSDictionary class]])
			{
				NSDictionary *deviceInfo = jsonBody[@"device"];
				token = deviceInfo[@"access_token"];
			}
		}
		self.authHolder.completed = YES;
		dispatch_async(dispatch_get_main_queue(),
		^{
			self.authCompletion(token, error);
		});
	}
	else if (task == self.getRestaurantsHolder.task)
	{
		NSArray *restaurantsFound = nil;
		if (nil == error)
		{
			NSMutableArray *restaurants = [NSMutableArray array];
			NSArray *jsonBody = [NSJSONSerialization
						JSONObjectWithData:self.getRestaurantsHolder.data options:NSJSONReadingMutableContainers error:NULL];
			for (id jsonObject in jsonBody)
			{
				[restaurants addObject:[[PWRestaurant alloc] initWithJSONInfo:jsonObject]];
			}
			restaurantsFound = restaurants;
		}
		
		self.getRestaurantsHolder.completed = YES;
		dispatch_async(dispatch_get_main_queue(),
		^{
			[self.cacher cacheRestaurants:restaurantsFound];
			self.getRestaurantsCompletion(restaurantsFound, error);
		});
	}
	else if (task == self.getNearItemsHolders.firstObject.task ||
				task == self.getNearItemsHolders[1].task ||
				task == self.getNearItemsHolders[2].task)
	{
		if (task == self.getNearItemsHolders.firstObject.task)
		{
			self.getNearItemsHolders.firstObject.completed = YES;
		}
		if (task == self.getNearItemsHolders[1].task)
		{
			self.getNearItemsHolders[1].completed = YES;
		}
		if (task == self.getNearItemsHolders[2].task)
		{
			self.getNearItemsHolders[2].completed = YES;
		}
		
		if (self.getNearItemsHolders.firstObject.completed &&
					self.getNearItemsHolders[1].completed &&
					self.getNearItemsHolders[2].completed)
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
	else if (task == self.getPresentsHolder.task)
	{
		self.getPresentsHolder.completed = YES;
		
		NSArray *presentsFound = nil;
		if (nil == error)
		{
			NSMutableArray *presents = [NSMutableArray array];
			NSArray *jsonBody = [NSJSONSerialization
						JSONObjectWithData:self.getPresentsHolder.data options:NSJSONReadingMutableContainers error:NULL];
			for (id jsonObject in jsonBody)
			{
				[presents addObject:[[PWPresentProduct alloc] initWithJSONInfo:jsonObject]];
			}
			presentsFound = presents;
		}
		dispatch_async(dispatch_get_main_queue(),
		^{
			[self.cacher cachePresents:presentsFound];
			self.getPresentsCompletion(presentsFound, error);
		});
	}
	else if (task == self.getSharesHolder.task)
	{
		self.getSharesHolder.completed = YES;
		
		NSArray *sharesFound = nil;
		if (nil == error)
		{
			NSMutableArray *shares = [NSMutableArray array];
			NSArray *jsonBody = [NSJSONSerialization
						JSONObjectWithData:self.getSharesHolder.data options:NSJSONReadingMutableContainers
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
			self.getSharesCompletion(sharesFound, error);
		});
	}
	else if (task == self.getPurchaseRestaurantsHolder.task)
	{
		NSArray *restaurantsFound = nil;
		if (nil == error)
		{
			NSMutableArray *restaurants = [NSMutableArray array];
			NSArray *jsonBody = [NSJSONSerialization
						JSONObjectWithData:self.getPurchaseRestaurantsHolder.data options:NSJSONReadingMutableContainers error:NULL];
			for (id jsonObject in jsonBody)
			{
				[restaurants addObject:[[PWRestaurant alloc] initWithJSONInfo:jsonObject]];
			}
			restaurantsFound = restaurants;
		}
		
		self.getPurchaseRestaurantsHolder.completed = YES;
		dispatch_async(dispatch_get_main_queue(),
		^{
			[self.cacher cachePurchaseRestaurants:restaurantsFound];
			self.getPurchaseRestaurantsCompletion(restaurantsFound, error);
		});
	}
	else if (task == self.getPurchasesHolder.task)
	{
		self.getPurchasesHolder.completed = YES;
		
		NSArray *purchasesFound = nil;
		if (nil == error)
		{
			NSMutableArray *purchases = [NSMutableArray array];
			NSArray *jsonBody = [NSJSONSerialization
						JSONObjectWithData:self.getPurchasesHolder.data
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
			self.getPurchasesCompletion(purchasesFound, error);
		});
	}
	else if (task == self.getActiveSharesHolders.firstObject.task ||
				task == self.getActiveSharesHolders[1].task ||
				task == self.getActiveSharesHolders[2].task)
	{
		if (task == self.getActiveSharesHolders.firstObject.task)
		{
			self.getActiveSharesHolders.firstObject.completed = YES;
		}
		if (task == self.getActiveSharesHolders[1].task)
		{
			self.getActiveSharesHolders[1].completed = YES;
		}
		if (task == self.getActiveSharesHolders[2].task)
		{
			self.getActiveSharesHolders[2].completed = YES;
		}
		
		if (self.getActiveSharesHolders.firstObject.completed &&
					self.getActiveSharesHolders[1].completed &&
					self.getActiveSharesHolders[2].completed)
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
	else if (task == self.getUserHolder.task)
	{
		PWUser *user = [self user];
		if (nil == error)
		{
			NSDictionary *jsonBody = [NSJSONSerialization
						JSONObjectWithData:self.getUserHolder.data
						options:NSJSONReadingMutableContainers error:NULL];
			[user updateWithJsonInfo:jsonBody];
		}
		self.getUserHolder.completed = YES;
		dispatch_async(dispatch_get_main_queue(),
		^{
			self.getUserCompletion(user, error);
		});
	}
	else if (task == self.signUpUserHolder.task)
	{
		self.signUpUserHolder.completed = YES;
		dispatch_async(dispatch_get_main_queue(),
		^{
			self.signUpUserCompletion(error);
		});
	}
	else if (task == self.signInUserHolder.task)
	{
		self.signInUserHolder.completed = YES;
		dispatch_async(dispatch_get_main_queue(),
		^{
			self.signInUserCompletion(error);
		});
	}
	else if (task == self.signUpSocialHolder.task)
	{
		self.signUpSocialHolder.completed = YES;
		dispatch_async(dispatch_get_main_queue(),
		^{
			self.signUpSocialCompletion(error);
		});
	}
	else if (task == self.updateUserInfoHolder.task)
	{
		self.updateUserInfoHolder.completed = YES;
		dispatch_async(dispatch_get_main_queue(),
		^{
			self.updateUserInfoCompletion(error);
		});
	}
}

@end
