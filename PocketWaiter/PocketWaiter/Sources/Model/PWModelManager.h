//
//  PWModelManager.h
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PWRestaurant.h"
#import "PWRestaurantAboutInfo.h"
#import "PWRestaurantShare.h"
#import "PWPresentProduct.h"
#import "PWPurchase.h"
#import "PWUser.h"

@interface PWModelManager : NSObject

+ (PWModelManager *)sharedManager;

- (PWUser *)registeredUser;

- (NSArray<PWRestaurant *> *)nearRestaurants;
- (NSArray<PWRestaurantShare *> *)nearShares;
- (NSArray<PWPresentProduct *> *)nearPresents;

- (void)getRestaurantsWithCount:(NSUInteger)count offset:(NSUInteger)offset
			completion:(void (^)(NSArray<PWRestaurant *> *))completion;

- (void)getSharesWithCount:(NSUInteger)count offset:(NSUInteger)offset
			completion:(void (^)(NSArray<PWRestaurantShare *> *))completion;

- (void)getPresentsWithCount:(NSUInteger)count offset:(NSUInteger)offset
			completion:(void (^)(NSArray<PWPresentProduct *> *))completion;

- (void)getPurchasesRestaurantsForUser:(PWUser *)user withCount:(NSUInteger)count
			offset:(NSUInteger)offset completion:
			(void (^)(NSArray<PWRestaurant *> *))completion;

- (void)getPurchasesForUser:(PWUser *)user restaurant:(PWRestaurant *)restaurant
			withCount:(NSUInteger)count
			offset:(NSUInteger)offset completion:
			(void (^)(NSArray<PWPurchase *> *))completion;

- (void)getRestaurantForBeacons:(NSArray<NSString *> *)beacons
			completion:(void (^)(PWRestaurant *restaurant, NSError *error))completion;

@end
