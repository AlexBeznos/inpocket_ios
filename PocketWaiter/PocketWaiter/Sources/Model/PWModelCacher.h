//
//  PWModelCacher.h
//  PocketWaiter
//
//  Created by Www Www on 10/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWModelCacher : NSObject

@property (nonatomic, strong) PWRestaurant *currentRestaurant;

@property (nonatomic, readonly) NSArray *restaurants;
- (void)cacheRestaurants:(NSArray *)restaurants;

@property (nonatomic, readonly) NSArray *nearShares;
- (void)cacheShares:(NSArray *)shares;

@property (nonatomic, readonly) NSArray *nearPresents;
- (void)cachePresents:(NSArray *)presents;

@property (nonatomic, readonly) NSArray *purchaseRestaurants;
- (void)cachePurchaseRestaurants:(NSArray *)restaurants;

@property (nonatomic, readonly) NSDictionary *purchases;
- (void)cachePurchases:(NSArray *)purchases forRestaurant:(PWRestaurant *)restaurant;

@property (nonatomic, readonly) NSDictionary *firstPresents;
- (void)cacheFirstPresent:(PWPresentProduct *)purchases forRestaurant:(PWRestaurant *)restaurant;
@property (nonatomic, readonly) NSDictionary *restaurantShares;
- (void)cacheShares:(NSArray *)shares forRestaurant:(PWRestaurant *)restaurant;
@property (nonatomic, readonly) NSDictionary *restaurantPresents;
- (void)cachePresents:(NSArray *)presents forRestaurant:(PWRestaurant *)restaurant;

@end
