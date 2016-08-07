//
//  PWRestaurant.m
//  PocketWaiter
//
//  Created by Www Www on 7/30/16.
//  Copyright © 2016 Www Www. All rights reserved.
//

#import "PWRestaurant.h"
#import "PWProduct.h"

@implementation PWRestaurant

- (NSArray<PWProduct *> *)firstPresents
{
	NSMutableArray *presents = [NSMutableArray new];
	
	for (PWProduct *product in self.products)
	{
		if (0 != (product.type & kPWProductTypeFirstPresent))
		{
			[presents addObject:product];
		}
	}
	
	return presents;
}

- (NSArray<PWProduct *> *)bestForDay
{
	NSMutableArray *presents = [NSMutableArray new];
	
	for (PWProduct *product in self.products)
	{
		if (0 != (product.type & kPWProductTypeBestForDay))
		{
			[presents addObject:product];
		}
	}
	
	return presents;
}

@end
