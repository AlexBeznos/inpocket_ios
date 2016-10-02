//
//  PWPurchase.m
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWPurchase.h"
#import "PWOrder.h"
#import "PWProduct.h"
#import "PWPrice.h"
#import "PWPresentProduct.h"

@interface PWPurchase ()

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray<PWOrder *> *orders;
@property (nonatomic, strong) NSArray<PWOrder *> *presents;
@property (nonatomic, strong) NSString *restaurantId;

@end

@implementation PWPurchase

- (instancetype)initWithFirstPresent:(PWPresentProduct *)present
{
	self = [super init];
	
	if (nil != self)
	{
		self.date = [NSDate date];
		PWOrder *presentOrder = [PWOrder new];
		presentOrder.count = 1;
		presentOrder.product = present;
		self.presents = @[presentOrder];
	}
	
	return self;
}

- (NSUInteger)bonusesCount
{
	NSUInteger count = 0;
	
	for (PWOrder *order in self.orders)
	{
		count += order.product.bonusesValue;
	}
	
	return count;
}

- (PWPrice *)totalPrice
{
	NSUInteger count = 0;
	
	for (PWOrder *order in self.orders)
	{
		count += order.product.price.value * order.count;
	}
	
	return [[PWPrice alloc] initWithValue:count
				currency:self.orders.firstObject.product.price.currency];
}

@end
