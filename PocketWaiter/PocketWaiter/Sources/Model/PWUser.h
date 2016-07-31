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

@interface PWUser : PWModelObject

@property (nonatomic, readonly) NSString *userName;
@property (nonatomic, readonly) NSString *password;
@property (nonatomic, readonly) NSString *humanReadableName;
@property (nonatomic, readonly) NSArray<PWPurchase *> *purchases;
@property (nonatomic, readonly) NSArray<PWUsersRestaurantInfo *> *restaurants;

@end
