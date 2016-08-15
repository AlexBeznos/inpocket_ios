//
//  PWRestaurantMapController.m
//  PocketWaiter
//
//  Created by Www Www on 8/15/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRestaurantMapController.h"
#import "PWRestaurant.h"

@interface PWRestaurantMapController ()

@property (nonatomic, strong) NSArray<PWRestaurant *> *restaurants;

@end

@implementation PWRestaurantMapController

- (instancetype)initWithRestaurants:(NSArray<PWRestaurant *> *)restaurants
{
	self = [super init];
	
	if (nil != self)
	{
		self.restaurants = restaurants;
	}
	
	return self;
}

- (NSArray<id<IPWRestaurant>> *)points
{
	return self.restaurants;
}

@end
