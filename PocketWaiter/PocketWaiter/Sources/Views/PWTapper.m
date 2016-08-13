//
//  PWTapper.m
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWTapper.h"
#import "UIColorAdditions.h"

@interface PWTapper ()

@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) NSLayoutConstraint *indicatorConstraint;
@property (nonatomic) NSUInteger selectedTapIndex;

@end

@implementation PWTapper

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
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

- (void)setFirstValue:(NSString *)firstValue
{
	self.firstLabel.text = firstValue;
}

- (NSString *)firstValue
{
	return self.firstLabel.text;
}

- (void)setSecondValue:(NSString *)secondValue
{
	self.secondLabel.text = secondValue;
}

- (NSString *)secondValue
{
	return self.secondLabel.text;
}

- (void)setup
{
	self.backgroundColor = [UIColor clearColor];
	self.firstValue = @"";
	self.secondValue = @"";
	
	UILabel *firstLabel = [UILabel new];
	
	[self setupLabel:firstLabel];
	
	UILabel *secondLabel = [UILabel new];
	
	[self setupLabel:secondLabel];
	
	[self addSubview:firstLabel];
	[self addSubview:secondLabel];
	
	[self addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]" options:0 metrics:nil
				views:@{@"view" : firstLabel}]];
	[self addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]" options:0 metrics:nil
				views:@{@"view" : secondLabel}]];
	
	[self addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[first]-13-[second]" options:0 metrics:nil
				views:@{@"first" : firstLabel, @"second" : secondLabel}]];
	
	UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[firstButton addTarget:self action:@selector(firstButtonTapped)
				forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[secondButton addTarget:self action:@selector(secondButtonTapped)
				forControlEvents:UIControlEventTouchUpInside];
	
	[self setupButton:firstButton];
	[self addSubview:firstButton];
	
	[self setupButton:secondButton];
	[self addSubview:secondButton];
	
	[self addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]" options:0 metrics:nil
				views:@{@"view" : firstButton}]];
	[self addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]" options:0 metrics:nil
				views:@{@"view" : secondButton}]];
	
	[self addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[first]-13-[second]" options:0 metrics:nil
				views:@{@"first" : firstButton, @"second" : secondButton}]];
	
	UIView *indicator = [UIView new];
	indicator.backgroundColor = [UIColor pwColorWithAlpha:1];
	indicator.translatesAutoresizingMaskIntoConstraints = NO;
	[indicator addConstraint:[NSLayoutConstraint
				constraintWithItem:indicator attribute:NSLayoutAttributeWidth
				relatedBy:NSLayoutRelationEqual toItem:nil
				attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:25]];
	[indicator addConstraint:[NSLayoutConstraint
				constraintWithItem:indicator attribute:NSLayoutAttributeHeight
				relatedBy:NSLayoutRelationEqual toItem:nil
				attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:3]];
	
	[self addSubview:indicator];
	
	[self addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:[label]-10-[indicator]" options:0 metrics:nil
				views:@{@"label" : firstLabel, @"indicator" : indicator}]];
	
	self.indicatorConstraint = [NSLayoutConstraint constraintWithItem:indicator
				attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual
				toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
	[self addConstraint:self.indicatorConstraint];
	
	self.firstLabel = firstLabel;
	self.secondLabel = secondLabel;
	
	self.selectedTapIndex = 0;
}

- (void)firstButtonTapped
{
	if (nil != self.tapHandler)
	{
		self.selectedTapIndex = 0;
		self.tapHandler(0);
	}
}

- (void)secondButtonTapped
{
	if (nil != self.tapHandler)
	{
		self.selectedTapIndex = 1;
		self.tapHandler(1);
	}
}

- (void)setSelectedTapIndex:(NSUInteger)selectedTapIndex
{
	_selectedTapIndex = selectedTapIndex;
	
	self.indicatorConstraint.constant = 0 == selectedTapIndex ? 0 : 93;
	self.firstLabel.textColor =
				[UIColor colorWithRed:0 green:0 blue:0
				alpha:0 == selectedTapIndex ? 1 : 0.3];
	self.secondLabel.textColor =
				[UIColor colorWithRed:0 green:0 blue:0
				alpha:0 == selectedTapIndex ? 0.3 : 1];
}

- (void)setupButton:(UIButton *)button
{
	button.backgroundColor = [UIColor clearColor];
	button.translatesAutoresizingMaskIntoConstraints = NO;
	[button addConstraint:[NSLayoutConstraint
				constraintWithItem:button attribute:NSLayoutAttributeWidth
				relatedBy:NSLayoutRelationEqual toItem:nil
				attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:80]];
	[button addConstraint:[NSLayoutConstraint
				constraintWithItem:button attribute:NSLayoutAttributeHeight
				relatedBy:NSLayoutRelationEqual toItem:nil
				attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:40]];
}


- (void)setupLabel:(UILabel *)label
{
	label.translatesAutoresizingMaskIntoConstraints = NO;
	[label addConstraint:[NSLayoutConstraint
				constraintWithItem:label attribute:NSLayoutAttributeWidth
				relatedBy:NSLayoutRelationEqual toItem:nil
				attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:80]];
	[label addConstraint:[NSLayoutConstraint
				constraintWithItem:label attribute:NSLayoutAttributeHeight
				relatedBy:NSLayoutRelationEqual toItem:nil
				attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:20]];
	label.font = [UIFont systemFontOfSize:14];
}

@end
