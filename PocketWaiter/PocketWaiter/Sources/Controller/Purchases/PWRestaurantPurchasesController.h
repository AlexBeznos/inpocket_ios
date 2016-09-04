//
//  PWRestaurantPurchasesController.h
//  PocketWaiter
//
//  Created by Www Www on 8/24/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWActivityIndicatorOwner.h"

@class PWRestaurant;
@class PWUser;

@interface PWRestaurantPurchasesController : PWActivityIndicatorOwner

- (instancetype)initWithUser:(PWUser *)user estimatedHeightHandler:(void (^)(CGFloat))handler;

- (void)updateWithRestaurant:(PWRestaurant *)restaurant;

@end
