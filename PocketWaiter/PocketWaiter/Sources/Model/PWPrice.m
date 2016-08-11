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
@property (nonatomic, strong) NSString *humanReadableValue;

@end

@implementation PWPrice

- (NSString *)humanReadableValue
{
	return [NSString stringWithFormat:@"%f $", self.value];
}

@end
