//
//  PWPresentProduct.m
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWPresentProduct.h"
#import "PWPrice.h"

@interface PWPresentProduct ()

@property (nonatomic) NSUInteger bonusesPrice;

@end

@interface PWProduct ()

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *productDescription;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) PWPrice *price;
@property (nonatomic) NSUInteger bonusesValue;
@property (nonatomic) PWProductType type;

@end

@implementation PWPresentProduct

+ (instancetype)firstPresentFromSourcePresent:(PWPresentProduct *)present
{
	return [[self alloc] initFromSourcePresent:present];
}

- (instancetype)initFromSourcePresent:(PWPresentProduct *)present
{
	self = [super init];
	
	if (nil != self && 0 != (present.type & kPWProductTypeFirstPresent))
	{
		self.bonusesPrice = 0;
		self.category = present.category;
		self.name = present.name;
		self.productDescription = present.productDescription;
		self.icon = present.icon;
		self.price = [[PWPrice alloc] initWithValue:present.price.value
					currency:present.price.currency];
		self.bonusesValue = present.bonusesValue;
		self.type = kPWProductTypeFirstPresent;
	}
	else
	{
		self = nil;
	}
	
	return self;
}

@end
