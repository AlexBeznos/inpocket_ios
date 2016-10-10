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
#import "PWOrder.h"
#import "PWPrice.h"
#import "PWUsersRestaurantInfo.h"
#import "PWRestaurantReview.h"

@interface PWModelManager : NSObject

+ (PWModelManager *)sharedManager;

- (PWUser *)registeredUser;

- (NSArray<PWRestaurant *> *)nearRestaurants;
- (NSArray<PWRestaurantShare *> *)nearShares;
- (NSArray<PWPresentProduct *> *)nearPresents;


- (void)getNearItemsWithCount:(NSUInteger)count
			completion:(void (^)(NSArray<PWRestaurant *> *nearRestaurant,
			NSArray<PWRestaurantShare *> *nearShares,
			NSArray<PWPresentProduct *> *nearPresents, NSError *error))completion;

- (void)getRestaurantsWithCount:(NSUInteger)count offset:(NSUInteger)offset
			completion:(void (^)(NSArray<PWRestaurant *> *, NSError *error))completion;

- (void)getSharesWithCount:(NSUInteger)count offset:(NSUInteger)offset
			completion:(void (^)(NSArray<PWRestaurantShare *> *, NSError *error))completion;

- (void)getPresentsWithCount:(NSUInteger)count offset:(NSUInteger)offset
			completion:(void (^)(NSArray<PWPresentProduct *> *, NSError *error))completion;

- (void)getPurchasesRestaurantsForUser:(PWUser *)user withCount:(NSUInteger)count
			offset:(NSUInteger)offset completion:
			(void (^)(NSArray<PWRestaurant *> *, NSError *error))completion;

- (void)getPurchasesForUser:(PWUser *)user restaurant:(PWRestaurant *)restaurant
			withCount:(NSUInteger)count
			offset:(NSUInteger)offset completion:
			(void (^)(NSArray<PWPurchase *> *, NSError *error))completion;

- (void)getRestaurantForBeacons:(NSArray<NSString *> *)beacons
			completion:(void (^)(PWRestaurant *restaurant, NSError *error))completion;

- (void)getFirstPresentsInfoForUser:(PWUser *)user restaurant:(PWRestaurant *)restaurant
			completion:(void (^)(PWPresentProduct *firstPresent, NSArray *shares, NSArray *presentByBonuses, NSError *error))completion;

- (void)getRecomendedProductsInfoForUser:(PWUser *)user restaurant:(PWRestaurant *)restaurant
			completion:(void (^)(NSArray<PWProduct *> *products, BOOL allowShare, BOOL allowComment, NSError *error))completion;

- (void)getRootMenuInfoForUser:(PWUser *)user restaurant:(PWRestaurant *)restaurant
			completion:(void (^)(NSArray<PWProduct *> *bestOfDay, NSDictionary<NSString *, NSArray<PWProduct *> *> *, NSError *error))completion;

- (void)getCommentsInfoForRestaurant:(PWRestaurant *)restaurant completion:(void (^)(BOOL allowComment, NSArray<PWRestaurantReview *> *, NSError *error))completion;

- (void)getAbilityToShareCommentWithCompletion:(void (^)(BOOL allowComment, NSError *error))completion;

- (void)sendReview:(PWRestaurantReview *)review completion:(void (^)(NSError *error))completion;

@end
