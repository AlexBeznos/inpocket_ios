//
//  PWDetailedNearSharesController.h
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWDetailedNearItemsController.h"

@class PWRestaurantShare;

@interface PWDetailedNearSharesController : PWDetailedNearItemsController

- (instancetype)initWithShares:(NSArray<PWRestaurantShare *> *)shares;

@end
