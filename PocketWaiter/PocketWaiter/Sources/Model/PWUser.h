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

@interface PWSocialProfile : NSObject

- (instancetype)initWithUuid:(NSString *)uuid email:(NSString *)email
			gender:(NSString *)gender name:(NSString *)name;

@property (nonatomic, readonly) NSString *uuid;
@property (nonatomic, readonly) NSString *email;
@property (nonatomic, readonly) NSString *gender;
@property (nonatomic, readonly) NSString *userName;

@end

@interface PWUser : PWModelObject

@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSString *password;
@property (nonatomic, readonly) NSString *email;
@property (nonatomic, readonly) UIImage *avatarIcon;
@property (nonatomic, readonly) PWSocialProfile *vkProfile;
@property (nonatomic, readonly) PWSocialProfile *fbProfile;
@property (nonatomic, readonly) NSArray<PWPurchase *> *purchases;
@property (nonatomic, readonly) NSArray<PWUsersRestaurantInfo *> *restaurants;

@property (nonatomic, readonly) NSDictionary<NSString *, PWPurchase *> *currentPurchases;

- (PWUsersRestaurantInfo *)infoForRestaurant:(PWRestaurant *)restaurant;

@end
