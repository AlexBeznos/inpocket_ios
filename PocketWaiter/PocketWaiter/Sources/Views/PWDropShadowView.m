//
//  PWDropShadowImageView.m
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWDropShadowView.h"

@implementation PWDropShadowView

- (instancetype)init
{
	self = [super init];
	
	if (nil != self)
	{
		[self setup];
	}
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if (nil != self)
	{
		[self setup];
	}
	
	return self;
}

- (void)addSubview:(UIView *)view
{
	[super addSubview:view];
	
	view.translatesAutoresizingMaskIntoConstraints = NO;
	[self addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]|" options:0
				metrics:nil views:@{@"view" : view}]];
	[self addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]|" options:0
				metrics:nil views:@{@"view" : view}]];
}

- (void)setup
{
	self.layer.shadowColor = [[UIColor grayColor] CGColor];
	self.layer.shadowOffset = CGSizeMake(5.0, 5.0);
	self.layer.shadowOpacity = 0.5;
	self.layer.shadowRadius = 5;
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
	self.layer.shadowOffset = shadowOffset;
}

@end
