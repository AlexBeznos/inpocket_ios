//
//  PWDetailedRestaurantsViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWDetailesItemsViewController.h"

@class PWRestaurant;

@interface PWDetailedRestaurantsViewController : PWDetailesItemsViewController

- (instancetype)initWithRestaurants:(NSArray<PWRestaurant *> *)restaurants;

@end
