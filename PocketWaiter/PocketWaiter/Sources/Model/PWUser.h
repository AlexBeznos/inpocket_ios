//
//  PWUser.h
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWModelObject.h"

@class PWPurchase;
@class PWUsersRestaurantInfo;
@class PWRestaurant;

@interface PWUser : PWModelObject

@property (nonatomic, readonly) NSString *userName;
@property (nonatomic, readonly) NSString *password;
@property (nonatomic, readonly) UIImage *avatarIcon;
@property (nonatomic, readonly) NSString *humanReadableName;
@property (nonatomic, readonly) NSArray<PWPurchase *> *purchases;
@property (nonatomic, readonly) NSArray<PWUsersRestaurantInfo *> *restaurants;

@property (nonatomic, readonly) NSDictionary<NSString *, PWPurchase *> *currentPurchases;

- (PWUsersRestaurantInfo *)infoForRestaurant:(PWRestaurant *)restaurant;

@end
