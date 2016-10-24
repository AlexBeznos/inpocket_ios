//
//  PWUser.h
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWModelObject.h"

@class PWPurchase;
@class PWRestaurant;

@interface PWSocialProfile : NSObject

- (instancetype)initWithUuid:(NSString *)uuid email:(NSString *)email
			gender:(NSString *)gender name:(NSString *)name photoURL:(NSString *)photoURLPath;

@property (nonatomic, readonly) NSString *uuid;
@property (nonatomic, readonly) NSString *email;
@property (nonatomic, readonly) NSString *gender;
@property (nonatomic, readonly) NSString *userName;
@property (nonatomic, readonly) NSString *photoURLPath;

@end

@interface PWUser : PWModelObject

@property (nonatomic, readonly) NSString *userName;
@property (nonatomic, readonly) NSString *password;
@property (nonatomic, readonly) NSString *email;
@property (nonatomic, readonly) UIImage *avatarIcon;
@property (nonatomic, strong) PWSocialProfile *vkProfile;
@property (nonatomic, strong) PWSocialProfile *fbProfile;
@property (nonatomic, readonly) NSArray<PWPurchase *> *purchases;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, readonly) NSString *referalId;

@property (nonatomic, readonly) NSDictionary<NSString *, PWPurchase *> *currentPurchases;

- (void)updateWithJsonInfo:(NSDictionary *)json;

@end
