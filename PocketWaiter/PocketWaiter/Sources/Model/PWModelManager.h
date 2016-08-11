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
#import "PWUser.h"

@interface PWModelManager : NSObject

+ (PWModelManager *)sharedManager;

- (PWUser *)registeredUser;

- (NSArray<PWRestaurant *> *)nearRestaurants;
- (NSArray<PWRestaurantShare *> *)nearShares;
- (NSArray<PWPresentProduct *> *)nearPresents;

@end
