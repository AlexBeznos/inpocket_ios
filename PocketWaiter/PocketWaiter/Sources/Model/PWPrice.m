//
//  PWPrice.m
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWPrice.h"

@interface PWPrice ()

@property (nonatomic) PWPriceCurrency currency;
@property (nonatomic) CGFloat value;

@end

@implementation PWPrice

- (instancetype)initWithValue:(CGFloat)value currency:(PWPriceCurrency)currency
{
	self = [super init];
	
	if (nil != self)
	{
		self.currency = currency;
		self.value = value;
	}
	
	return self;
}

- (NSString *)humanReadableValue
{
	return [NSString stringWithFormat:@"%.2f $", self.value];
}

@end
