//
//  PWModelCacher.m
//  PocketWaiter
//
//  Created by Www Www on 10/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWModelCacher.h"

@interface PWModelCacher ()

@property (nonatomic, strong) NSMutableArray *cachedRestaurants;

@end

@implementation PWModelCacher

- (instancetype)init
{
	self = [super init];
	
	if (nil != self)
	{
		self.cachedRestaurants = [NSMutableArray array];
	}
	
	return self;
}

- (NSArray *)restaurants
{
	return [NSArray arrayWithArray:self.cachedRestaurants];
}

- (void)cacheRestaurants:(NSArray *)restaurants
{
	for (PWRestaurant *restaurant in restaurants)
	{
		BOOL restaurantIsNew = YES;
		for (PWRestaurant *cachedRestaurant in self.cachedRestaurants)
		{
			if ([restaurant.identifier isEqualToNumber:cachedRestaurant.identifier])
			{
				restaurantIsNew = NO;
				break;
			}
		}
		
		if (restaurantIsNew)
		{
			[self.cachedRestaurants addObject:restaurant];
		}
	}
}

@end
