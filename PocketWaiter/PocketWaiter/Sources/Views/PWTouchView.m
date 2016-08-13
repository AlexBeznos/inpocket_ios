//
//  PWTouchView.m
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWTouchView.h"

@interface PWTouchView ()

@property (nonatomic, copy)void (^handler)();

@end

@implementation PWTouchView

- (instancetype)initWithTouchHandler:(void (^)())aHandler
{
	self = [super init];
	
	if (nil != self)
	{
		self.backgroundColor = [UIColor clearColor];
		self.handler = aHandler;
	}
	
	return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	if (nil != self.handler)
	{
		self.handler();
	}
	
	return self;
}

@end
