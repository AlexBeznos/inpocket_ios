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

@property (nonatomic, strong) PWRequestHolder *getRestaurantsHolder;
@property (nonatomic, copy) void (^getRestaurantsCompletion)
			(NSArray<PWRestaurant *> *, NSError *error);

//@property (nonatomic, strong) PWRequestHolder *getNearItemsHolder;
//@property (nonatomic, copy) void (^getRestaurantsCompletion)
//			(NSArray<PWRestaurant *> *, NSError *error);

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
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
				(int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
	^{
		if (nil != completion)
		{
			completion(self.nearShares, nil);
		}
	});
}

- (void)getPresentsWithCount:(NSUInteger)count offset:(NSUInteger)offset
			completion:(void (^)(NSArray<PWPresentProduct *> *, NSError *error))completion
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
				(int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
	^{
		if (nil != completion)
		{
			completion(self.nearPresents, nil);
		}
	});
}

- (void)getPurchasesRestaurantsForUser:(PWUser *)user withCount:(NSUInteger)count
			offset:(NSUInteger)offset completion:
			(void (^)(NSArray<PWRestaurant *> *, NSError *error))completion
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
				(int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
	^{
		if (nil != completion)
		{
			completion(self.cachedRestaurants, nil);
		}
	});
}

- (void)getPurchasesForUser:(PWUser *)user restaurant:(PWRestaurant *)restaurant
			withCount:(NSUInteger)count
			offset:(NSUInteger)offset completion:
			(void (^)(NSArray<PWPurchase *> *, NSError *error))completion
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
				(int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
	^{
		if (nil != completion)
		{
			completion(self.user.purchases, nil);
		}
	});
}

- (void)getRestaurantForBeacons:(NSArray<NSString *> *)beacons
			completion:(void (^)(PWRestaurant *restaurant, NSError *error))completion
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
				(int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
	^{
		if (nil != completion)
		{
			completion([self.cachedRestaurants firstObject], nil);
		}
	});
}

- (void)getFirstPresentsInfoForUser:(PWUser *)user restaurant:(PWRestaurant *)restaurant
			completion:(void (^)(PWPresentProduct *firstPresent, NSArray *shares, NSArray *presentByBonuses, NSError *error))completion
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
				(int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
	^{
		if (nil != completion)
		{
			completion(restaurant.presents.firstObject, restaurant.shares, restaurant.presents, nil);
		}
	});
}

- (void)getNearItemsWithCount:(NSUInteger)count
			completion:(void (^)(NSArray<PWRestaurant *> *nearRestaurant,
			NSArray<PWRestaurantShare *> *nearShares,
			NSArray<PWPresentProduct *> *nearPresents, NSError *error))completion
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
				(int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
	^{
		if (nil != completion)
		{
			completion(self.cachedRestaurants, self.nearShares, self.nearPresents, nil);
		}
	});
}

- (void)getRecomendedProductsInfoForUser:(PWUser *)user restaurant:(PWRestaurant *)restaurant
			completion:(void (^)(NSArray<PWProduct *> *products, BOOL allowShare, BOOL allowComment, NSError *error))completion
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
				(int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
	^{
		if (nil != completion)
		{
			completion(restaurant.products, YES, YES, nil);
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

- (void)getAbilityToShareCommentWithCompletion:(void (^)(BOOL allowComment, NSError *error))completion
{
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
				(int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
	^{
		if (nil != completion)
		{
			completion(YES, nil);
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

- (NSArray<PWRestaurant *> *)nearRestaurants
{
	return self.cachedRestaurants;
}

- (NSArray<PWRestaurantShare *> *)nearShares
{
	NSMutableArray<PWRestaurantShare *> *shares = [NSMutableArray array];
	
	for (PWRestaurant *restaurant in self.cachedRestaurants)
	{
		[shares addObjectsFromArray:restaurant.shares];
	}
	
	return shares;
}

- (NSArray<PWPresentProduct *> *)nearPresents
{
	NSMutableArray<PWPresentProduct *> *presents = [NSMutableArray array];
	
	for (PWRestaurant *restaurant in self.cachedRestaurants)
	{
		[presents addObjectsFromArray:restaurant.presents];
	}
	
	return presents;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
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
	
	[holder processResponse:(NSHTTPURLResponse *)response];
	
	completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
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
			self.getRestaurantsCompletion(restaurantsFound, error);
		});
	}
}

- (void)setupStubbedInfo
{
	self.user = [PWUser new];
	self.user.userName = @"user_name";
	self.user.password = @"psd";
	self.user.humanReadableName = @"Vasya Pupkin";
	self.user.avatarIcon = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"coffeetoria" ofType:@"jpeg"]];
	
	PWUsersRestaurantInfo *info1 = [PWUsersRestaurantInfo new];
	info1.restaurantId = @"Vapiano";
	info1.collectedBonuses = 100;
	
	PWUsersRestaurantInfo *info2 = [PWUsersRestaurantInfo new];
	info2.restaurantId = @"Coffeetoria";
	info2.collectedBonuses = 200;
	
	self.user.restaurants = @[info1, info2];
	
	PWPurchase *purchase1 = [PWPurchase new];
	purchase1.date = [NSDate date];
	purchase1.restaurantId = @"Vapiano";
	
	PWPurchase *purchase2 = [PWPurchase new];
	purchase2.date = [NSDate dateWithTimeInterval:20000 sinceDate:[NSDate date]];
	purchase2.restaurantId = @"Vapiano";
	
	PWPurchase *purchase3 = [PWPurchase new];
	purchase3.date = [NSDate date];
	purchase3.restaurantId = @"Coffeetoria";
	
	PWProduct *product = [PWProduct new];
	product.category = @"Drinks";
	product.name = @"Mohito";
	product.productDescription = @"Delisious fresh drink";
	product.icon = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"mohito" ofType:@"jpg"]];
	PWPrice *price = [PWPrice new];
	price.value = 20;
	price.currency = kPWPriceCurrencyUAH;
	product.price = price;
	
	product.bonusesValue = 15;
	product.type = kPWProductTypeRegular | kPWProductTypeFirstPresent |
				kPWProductTypeBestForDay;
	
	PWProduct *product2 = [PWProduct new];
	product2.category = @"Burgers";
	product2.name = @"Burger";
	product2.productDescription = @"Delisious food";
	product2.icon = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"burger" ofType:@"jpg"]];
	PWPrice *price2 = [PWPrice new];
	price2.value = 35;
	price2.currency = kPWPriceCurrencyUAH;
	product2.price = price2;
	
	product2.bonusesValue = 25;
	product2.type = kPWProductTypeRegular;

	PWOrder *order1 = [PWOrder new];
	order1.product = product;
	order1.count = 2;
	
	PWOrder *order2 = [PWOrder new];
	order2.product = product2;
	order2.count = 2;
	
	purchase1.orders = @[order1, order2];
	purchase2.orders = @[order1, order2];
	purchase3.orders = @[order1, order2];
	
	self.user.purchases = @[purchase1, purchase2, purchase3];
	
	PWRestaurant *restaurant1 = [PWRestaurant new];
	
	PWRestaurantAboutInfo *about1 = [PWRestaurantAboutInfo new];
	about1.name = @"Vapiano";
	about1.color = [UIColor redColor];
	about1.address = @"Kyev, Garmatna street, 5 building";
	about1.phoneNumber = @"066-12-12-123";
	about1.location = [[CLLocation alloc] initWithLatitude:50.46 longitude:30.51];
	about1.restaurantDescription = @"Very nice restaurant";
	about1.restaurantImage = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"vapiano" ofType:@"jpeg"]];
	about1.photos = @[[UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"vapiano_1" ofType:@"jpg"]],
				[UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"vapiano_2" ofType:@"jpg"]],
				[UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"vapiano_3" ofType:@"jpg"]]];
	PWRestaurantReview *review1 = [PWRestaurantReview new];
	review1.userIcon = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"vapiano" ofType:@"jpeg"]];
	review1.userName = @"VasyaPupkin";
	review1.date = [NSDate date];
	review1.reviewDescription = @"Very nice mohito\nsdfsdfsdf\ndfgadfgdfaadfg aesg dsgsd fz fchzdsF Dsdfd\nnsFsd fds fsdfd\nsdfsd fasdf sdfsdfds\nsfdgs dfgdfsg\n \n dfgzfdgf \n dzg dfgfd \n !!";
	review1.photo = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"vapiano_1" ofType:@"jpg"]];
	review1.rank = 3;
	PWRestaurantReview *review2 = [PWRestaurantReview new];
	review2.userIcon = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"vapiano" ofType:@"jpeg"]];
	review2.userName = @"VasyaPupkin";
	review2.date = [NSDate date];
	review2.reviewDescription = @"Very nice burger!!";
	review2.photo = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"vapiano_2" ofType:@"jpg"]];
	review2.rank = 5;
	about1.reviews = @[review1, review2];
	
	PWWorkingTime *time1 = [PWWorkingTime new];
	time1.dayType = kPWWeekDaNameMon;
	time1.startTime = 60 * 60 * 8;
	time1.startTime = 60 * 60 * 20;
	
	PWWorkingTime *time2 = [PWWorkingTime new];
	time2.dayType = kPWWeekDaNameTue;
	time2.startTime = 60 * 60 * 8;
	time2.startTime = 60 * 60 * 20;
	
	PWWorkingTime *time3 = [PWWorkingTime new];
	time3.dayType = kPWWeekDaNameWen;
	time3.startTime = 60 * 60 * 8;
	time3.startTime = 60 * 60 * 20;
	
	PWWorkingTime *time4 = [PWWorkingTime new];
	time4.dayType = kPWWeekDaNameThu;
	time4.startTime = 60 * 60 * 8;
	time4.startTime = 60 * 60 * 20;
	
	PWWorkingTime *time5 = [PWWorkingTime new];
	time5.dayType = kPWWeekDaNameFri;
	time5.startTime = 60 * 60 * 8;
	time5.startTime = 60 * 60 * 20;
	
	PWWorkingTime *time6 = [PWWorkingTime new];
	time6.dayType = kPWWeekDaNameSat;
	time6.startTime = 60 * 60 * 8;
	time6.startTime = 60 * 60 * 20;
	
	PWWorkingTime *time7 = [PWWorkingTime new];
	time7.dayType = kPWWeekDaNameSun;
	time7.startTime = 60 * 60 * 8;
	time7.startTime = 60 * 60 * 20;
	
	about1.workingPlan = @[time1, time2, time3, time4, time5, time6, time7];
	
	restaurant1.aboutInfo = about1;
	
	PWRestaurantShare *share1 = [PWRestaurantShare new];
	share1.name = @"Burger + cola";
	share1.shareDescription = @"buy burger and receive free cola\n\nblah\nblah blah\n\nblah";
	share1.image = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"burger" ofType:@"jpg"]];
	
	PWRestaurantShare *share2 = [PWRestaurantShare new];
	share2.name = @"Free mohito";
	share2.shareDescription = @"First mohito is free";
	share2.image = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"mohito" ofType:@"jpg"]];
	
	restaurant1.shares = @[share1, share2];
	
	PWProduct *restaurantProduct = [PWProduct new];
	restaurantProduct.category = @"Drinks";
	restaurantProduct.name = @"Mohito";
	restaurantProduct.productDescription = @"Delisious fresh drink";
	restaurantProduct.icon = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"mohito" ofType:@"jpg"]];
	
	price = [PWPrice new];
	price.value = 20;
	price.currency = kPWPriceCurrencyUAH;
	restaurantProduct.price = price;
	
	restaurantProduct.bonusesValue = 15;
	restaurantProduct.type = kPWProductTypeRegular | kPWProductTypeFirstPresent |
				kPWProductTypeBestForDay;
	
	PWProduct *restaurantProduct1 = [PWProduct new];
	restaurantProduct1.category = @"Drinks";
	restaurantProduct1.name = @"Juice";
	restaurantProduct1.productDescription = @"Delisious fresh juice";
	restaurantProduct1.icon = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"juice" ofType:@"jpg"]];
	
	price = [PWPrice new];
	price.value = 20;
	price.currency = kPWPriceCurrencyUAH;
	restaurantProduct1.price = price;
	
	restaurantProduct1.bonusesValue = 15;
	restaurantProduct1.type = kPWProductTypeRegular | kPWProductTypeFirstPresent;
	
	PWProduct *restaurantProduct2 = [PWProduct new];
	restaurantProduct2.category = @"Hookah";
	restaurantProduct2.name = @"Tanjir";
	restaurantProduct2.productDescription = @"For hardcore smokers";
	restaurantProduct2.icon = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"hookah1" ofType:@"jpeg"]];
	
	price = [PWPrice new];
	price.value = 200;
	price.currency = kPWPriceCurrencyUAH;
	restaurantProduct2.price = price;
	
	restaurantProduct2.bonusesValue = 100;
	restaurantProduct2.type = kPWProductTypeRegular;
	
	PWProduct *restaurantProduct3 = [PWProduct new];
	restaurantProduct3.category = @"Hookah";
	restaurantProduct3.name = @"Foomary";
	restaurantProduct3.productDescription = @"Light and cool";
	restaurantProduct3.icon = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"hookah2" ofType:@"jpeg"]];
	
	price = [PWPrice new];
	price.value = 200;
	price.currency = kPWPriceCurrencyUAH;
	restaurantProduct3.price = price;
	
	restaurantProduct3.bonusesValue = 100;
	restaurantProduct3.type = kPWProductTypeRegular | kPWProductTypeBestForDay;
	
	restaurant1.products = @[restaurantProduct, restaurantProduct1,
				restaurantProduct2, restaurantProduct3];
	
	PWPresentProduct *presentProduct1 = [PWPresentProduct new];
	presentProduct1.category = @"Drinks";
	presentProduct1.name = @"Juice";
	presentProduct1.productDescription = @"Delisious fresh juice";
	presentProduct1.icon = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"juice" ofType:@"jpg"]];
	
	presentProduct1.type = kPWProductTypeRegular;
	presentProduct1.bonusesPrice = 25;
	
	PWPresentProduct *presentProduct2 = [PWPresentProduct new];
	presentProduct2.category = @"Hookah";
	presentProduct2.name = @"Tanjir";
	presentProduct2.productDescription = @"For hardcore smokers";
	presentProduct2.icon = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"hookah1" ofType:@"jpeg"]];
	
	presentProduct2.type = kPWProductTypeRegular;
	
	restaurant1.presents = @[presentProduct1, presentProduct2];
	
	PWRestaurant *restaurant2 = [PWRestaurant new];
	
	PWRestaurantAboutInfo *about2 = [PWRestaurantAboutInfo new];
	about2.name = @"Coffeetoria";
	about2.address = @"Kyev, Peremogi ave, 27a";
	about2.phoneNumber = @"066-12-12-124";
	about2.location = [[CLLocation alloc] initWithLatitude:50.45 longitude:30.44];
	about2.restaurantDescription = @"Very nice lounge";
	about2.restaurantImage = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"coffeetoria" ofType:@"jpg"]];
	about2.photos = @[[UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"coffeetoria1" ofType:@"jpg"]],
				[UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"coffeetoria2" ofType:@"jpg"]],
				[UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"coffeetoria3" ofType:@"jpg"]]];
	review1 = [PWRestaurantReview new];
	review1.userIcon = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"coffeetoria" ofType:@"jpg"]];
	review1.userName = @"VasyaPupkin";
	review1.date = [NSDate date];
	review1.reviewDescription = @"Very nice mohito\nsdfsdfsdf\ndfgadfgdfaadfg aesg dsgsd fz fchzdsF Dsdfd\nnsFsd fds fsdfd\nsdfsd fasdf sdfsdfds\nsfdgs dfgdfsg\n \n dfgzfdgf \n dzg dfgfd \n !!";
	review1.photo = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"hookah" ofType:@"jpg"]];
	review1.rank = 3;
	review2 = [PWRestaurantReview new];
	review2.userIcon = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"coffeetoria" ofType:@"jpg"]];
	review2.userName = @"VasyaPupkin";
	review2.date = [NSDate date];
	review2.reviewDescription = @"Very nice burger!!";
	review2.photo = [UIImage imageWithContentsOfFile:
				[[NSBundle mainBundle] pathForResource:@"coffeetoria2" ofType:@"jpg"]];
	review2.rank = 5;
	about2.reviews = @[review1, review2];
	about2.color = [UIColor greenColor];
	
	about2.workingPlan = @[time1, time2, time3, time4, time5, time6, time7];
	
	restaurant2.aboutInfo = about2;
	
	restaurant2.shares = @[share1, share2];
	share1.restaurant = restaurant2;
	share2.restaurant = restaurant2;
	
	restaurant2.products = @[restaurantProduct, restaurantProduct1,
				restaurantProduct2, restaurantProduct3];
	
	restaurant2.presents = @[presentProduct1, presentProduct2];
	presentProduct1.restaurant = restaurant2;
	presentProduct2.restaurant = restaurant2;
	
	self.cachedRestaurants = @[restaurant1, restaurant2];
}

@end
