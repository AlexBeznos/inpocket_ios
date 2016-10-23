//
//  PWOrder.m
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWOrder.h"

@implementation PWOrder

- (instancetype)initWithJSONInfo:(id)jsonInfo
{
	self = [super initWithJSONInfo:jsonInfo];
	
	if (nil != self && [jsonInfo isKindOfClass:[NSDictionary class]])
	{
		self.count = 1;
		self.product = [[PWProduct alloc] initWithJSONInfo:jsonInfo];
	}
	else
	{
		self = nil;
	}
	
	return self;
}

@end
