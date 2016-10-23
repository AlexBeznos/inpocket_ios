//
//  PWProduct.m
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWProduct.h"

@interface PWProduct ()

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *productDescription;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) PWPrice *price;
@property (nonatomic) NSUInteger bonusesValue;
@property (nonatomic) PWProductType type;
@property (nonatomic, strong) NSString *iconPath;

@end

@implementation PWProduct

- (instancetype)initWithJSONInfo:(id)jsonInfo
{
	self = [super initWithJSONInfo:jsonInfo];
	
	if (nil != self && [jsonInfo isKindOfClass:[NSDictionary class]])
	{
		NSDictionary *info = (NSDictionary *)jsonInfo;
		self.name = info[@"name"];
		NSString *price = info[@"price"];
		self.price = [[PWPrice alloc] initWithValue:price.integerValue
					currency:kPWPriceCurrencyUAH];
		self.iconPath = info[@"image"];
		self.productDescription = info[@"description"];
		self.bonusesValue = [info[@"bonus"] integerValue];
		self.type = kPWProductTypeRegular;
	}
	else
	{
		self = nil;
	}
	
	return self;
}

- (UIImage *)icon
{
	return [UIImage imageWithContentsOfFile:self.downloadedIconPath];
}

@end
