//
//  PWRestaurantMapController.h
//  PocketWaiter
//
//  Created by Www Www on 8/15/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWMapController.h"

@class PWRestaurant;

@interface PWRestaurantMapController : PWMapController

- (instancetype)initWithRestaurants:(NSArray<PWRestaurant *> *)restaurants
			selectedRestaurant:(PWRestaurant *)restaurant
			transiter:(id<IPWTransiter>)transiter;

@end
