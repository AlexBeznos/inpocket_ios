//
//  PWButton.m
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWButton.h"

@interface PWButton ()

@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIImageView *arrowView;

@end

@implementation PWButton

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

- (void)setup
{
	self.infoLabel = [UILabel new];
	self.infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
	self.infoLabel.backgroundColor = [UIColor clearColor];
	self.infoLabel.font = [UIFont systemFontOfSize:15];
	[self addSubview:self.infoLabel];
	
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
				@"H:|-10-[view]" options:0 metrics:nil views:@{@"view": self.infoLabel}]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.infoLabel
				attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
				toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
	
	self.arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whiteLittleArrow"]];
	self.arrowView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.arrowView sizeToFit];
	[self.arrowView addConstraint:[NSLayoutConstraint constraintWithItem:self.arrowView
				attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
				toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0
				constant:CGRectGetWidth(self.arrowView.frame)]];
	[self.arrowView addConstraint:[NSLayoutConstraint constraintWithItem:self.arrowView
				attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
				toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0
				constant:CGRectGetHeight(self.arrowView.frame)]];
	
	[self addSubview:self.arrowView];
	
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
				@"H:[view]-10-|" options:0 metrics:nil views:@{@"view": self.arrowView}]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.arrowView
				attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
				toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

- (void)setBgColor:(UIColor *)bgColor
{
	self.backgroundColor = bgColor;
}

- (UIColor *)bgColor
{
	return self.backgroundColor;
}

- (void)setColorScheme:(UIColor *)colorScheme
{
	self.infoLabel.textColor = colorScheme;
	NSString *imageName = @"whiteLittleArrow";
	if (![colorScheme isEqual:[UIColor whiteColor]])
	{
		imageName = @"blackLittleArrow";
	}
	
	self.arrowView.image = [UIImage imageNamed:imageName];
}

- (UIColor *)colorScheme
{
	return self.infoLabel.textColor;
}

- (void)setTitle:(NSString *)title
{
	self.infoLabel.text = title;
}

- (NSString *)title
{
	return self.infoLabel.text;
}

- (void)changeImageWithImage:(NSString *)imageName
{
    self.arrowView.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.arrowView setTintColor: [UIColor whiteColor]];
}

@end
