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
@property (nonatomic, strong) NSMutableArray *cachedShares;
@property (nonatomic, strong) NSMutableArray *cachedPresents;

@end

@implementation PWModelCacher

- (instancetype)init
{
	self = [super init];
	
	if (nil != self)
	{
		self.cachedRestaurants = [NSMutableArray array];
		self.cachedShares = [NSMutableArray array];
		self.cachedPresents = [NSMutableArray array];
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

- (NSArray *)shares
{
	return self.cachedShares;
}

- (void)cacheShares:(NSArray *)shares
{
	for (PWRestaurantShare *share in shares)
	{
		BOOL shareIsNew = YES;
		for (PWRestaurant *cachedShares in self.cachedShares)
		{
			if ([share.identifier isEqualToNumber:cachedShares.identifier])
			{
				shareIsNew = NO;
				break;
			}
		}
		
		if (shareIsNew)
		{
			[self.cachedShares addObject:share];
		}
	}
}

- (NSArray *)presents
{
	return self.cachedPresents;
}

- (void)cachePresents:(NSArray *)presents
{
	for (PWRestaurantShare *present in presents)
	{
		BOOL presentIsNew = YES;
		for (PWRestaurant *cachedPresent in self.cachedPresents)
		{
			if ([present.identifier isEqualToNumber:cachedPresent.identifier])
			{
				presentIsNew = NO;
				break;
			}
		}
		
		if (presentIsNew)
		{
			[self.cachedPresents addObject:present];
		}
	}
}

@end
