//
//  PWDetailedNearRestaurantsController.h
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWDetailedNearItemsCollectionController.h"

@class PWRestaurant;

@interface PWRestaurantsCollectionController : PWDetailedNearItemsCollectionController

- (instancetype)initWithRestaurants:(NSArray<PWRestaurant *> *)restaurants
			transiter:(id<IPWTransiter>)transiter;

@end
