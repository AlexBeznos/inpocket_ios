//
//  PWDetailedNearRestaurantsController.h
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWDetailedNearItemsController.h"

@class PWRestaurant;

@interface PWRestaurantsCollectionController : PWDetailedNearItemsController

- (instancetype)initWithRestaurants:(NSArray<PWRestaurant *> *)restaurants;

@end
