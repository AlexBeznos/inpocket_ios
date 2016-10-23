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
@property (nonatomic, strong) NSMutableArray *cachedPurchaseRestaurants;
@property (nonatomic, strong) NSMutableDictionary *cachedPurchases;

@property (nonatomic, strong) NSMutableDictionary *cachedRestaurantShares;
@property (nonatomic, strong) NSMutableDictionary *cachedRestaurantPresents;
@property (nonatomic, strong) NSMutableDictionary *cachedFirstPresents;

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
		self.cachedPurchaseRestaurants = [NSMutableArray array];
		self.cachedPurchases = [NSMutableDictionary dictionary];
		
		self.cachedRestaurantShares = [NSMutableDictionary dictionary];
		self.cachedRestaurantPresents = [NSMutableDictionary dictionary];
		self.cachedFirstPresents = [NSMutableDictionary dictionary];
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

- (NSArray *)nearShares
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

- (NSArray *)nearPresents
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

- (NSArray *)purchaseRestaurants
{
	return self.cachedPurchaseRestaurants;
}

- (void)cachePurchaseRestaurants:(NSArray *)restaurants
{
	for (PWRestaurant *restaurant in restaurants)
	{
		BOOL restaurantIsNew = YES;
		for (PWRestaurant *cachedRestaurant in self.cachedPurchaseRestaurants)
		{
			if ([restaurant.identifier isEqualToNumber:cachedRestaurant.identifier])
			{
				restaurantIsNew = NO;
				break;
			}
		}
		
		if (restaurantIsNew)
		{
			[self.cachedPurchaseRestaurants addObject:restaurant];
		}
	}
}

- (NSDictionary *)purchases
{
	return self.cachedPurchases;
}

- (void)cachePurchases:(NSArray *)purchases forRestaurant:(PWRestaurant *)restaurant
{
	NSMutableArray *purchasesForRestaurant = [NSMutableArray array];
	NSArray *cachedPurchases = self.cachedPurchases[restaurant.identifier.stringValue];
	if (nil != cachedPurchases)
	{
		[purchasesForRestaurant addObjectsFromArray:cachedPurchases];
	}
	for (PWPurchase *purchase in purchases)
	{
		BOOL purchaseIsNew = YES;
		NSUInteger index = NSNotFound;
		for (PWPurchase *cachedPurchase in purchasesForRestaurant)
		{
			if ([purchase.identifier isEqualToNumber:cachedPurchase.identifier])
			{
				purchaseIsNew = NO;
				index = [purchasesForRestaurant indexOfObject:cachedPurchase];
				break;
			}
		}
		
		if (purchaseIsNew)
		{
			[purchasesForRestaurant addObject:purchase];
		}
		else
		{
			[purchasesForRestaurant replaceObjectAtIndex:index withObject:purchase];
		}
	}
	
	self.cachedPurchases[restaurant.identifier.stringValue] = purchasesForRestaurant;
}

- (NSDictionary *)firstPresents
{
	return self.cachedFirstPresents;
}

- (void)cacheFirstPresent:(PWPresentProduct *)firstPresent forRestaurant:(PWRestaurant *)restaurant
{
	self.cachedFirstPresents[restaurant.identifier.stringValue] = firstPresent;
}

- (NSDictionary *)restaurantShares
{
	return self.cachedRestaurantShares;
}

- (void)cacheShares:(NSArray *)shares forRestaurant:(PWRestaurant *)restaurant
{
	NSMutableArray *sharesForRestaurant = [NSMutableArray array];
	NSArray *cachedShares = self.cachedRestaurantShares[restaurant.identifier.stringValue];
	if (nil != cachedShares)
	{
		[sharesForRestaurant addObjectsFromArray:cachedShares];
	}
	for (PWRestaurantShare *share in shares)
	{
		BOOL shareIsNew = YES;
		NSUInteger index = NSNotFound;
		for (PWRestaurantShare *cachedShare in sharesForRestaurant)
		{
			if ([share.identifier isEqualToNumber:cachedShare.identifier])
			{
				shareIsNew = NO;
				index = [sharesForRestaurant indexOfObject:cachedShare];
				break;
			}
		}
		
		if (shareIsNew)
		{
			[sharesForRestaurant addObject:share];
		}
		else
		{
			[sharesForRestaurant replaceObjectAtIndex:index withObject:share];
		}
	}
	
	self.cachedRestaurantShares[restaurant.identifier.stringValue] = sharesForRestaurant;
}

- (NSDictionary *)restaurantPresents
{
	return self.cachedRestaurantPresents;
}

- (void)cachePresents:(NSArray *)presents forRestaurant:(PWRestaurant *)restaurant
{
	NSMutableArray *presentsForRestaurant = [NSMutableArray array];
	NSArray *cachedPresents = self.cachedRestaurantPresents[restaurant.identifier.stringValue];
	if (nil != cachedPresents)
	{
		[presentsForRestaurant addObjectsFromArray:cachedPresents];
	}
	for (PWPresentProduct *present in presents)
	{
		BOOL presentIsNew = YES;
		NSUInteger index = NSNotFound;
		for (PWPresentProduct *cachedPresent in presentsForRestaurant)
		{
			if ([present.identifier isEqualToNumber:cachedPresent.identifier])
			{
				presentIsNew = NO;
				index = [presentsForRestaurant indexOfObject:cachedPresent];
				break;
			}
		}
		
		if (presentIsNew)
		{
			[presentsForRestaurant addObject:present];
		}
		else
		{
			[presentsForRestaurant replaceObjectAtIndex:index withObject:present];
		}
	}
	
	self.cachedRestaurantPresents[restaurant.identifier.stringValue] = presentsForRestaurant;
}

@end
