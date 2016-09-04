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

@interface PWPurchase ()

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray<PWOrder *> *orders;
@property (nonatomic, strong) NSArray<PWOrder *> *presents;
@property (nonatomic, strong) NSString *restaurantId;

@end

@implementation PWPurchase

- (NSUInteger)bonusesCount
{
	NSUInteger count = 0;
	
	for (PWOrder *order in self.orders)
	{
		count += order.product.bonusesValue;
	}
	
	return count;
}

@end
