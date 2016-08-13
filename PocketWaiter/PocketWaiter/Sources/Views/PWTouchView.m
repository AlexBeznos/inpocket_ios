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
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.backgroundColor = [UIColor clearColor];
		[button addTarget:self action:@selector(tapped)
					forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:button];
		button.translatesAutoresizingMaskIntoConstraints = NO;
		[self addConstraints:[NSLayoutConstraint
					constraintsWithVisualFormat:@"V:|[view]|"
					options:0 metrics:nil
					views:@{@"view" : button}]];
		[self addConstraints:[NSLayoutConstraint
					constraintsWithVisualFormat:@"H:|[view]|"
					options:0 metrics:nil
					views:@{@"view" : button}]];

	}
	
	return self;
}

- (void)tapped
{
	if (nil != self.handler)
	{
		self.handler();
		self.handler = nil;
	}
}

@end
