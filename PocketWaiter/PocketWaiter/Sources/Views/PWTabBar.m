//
//  PWTabBar.m
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWTabBar.h"

@interface PWTabBarItem ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) void (^handler)();

@end

@implementation PWTabBarItem

- (instancetype)initWithTitle:(NSString *)title handler:(void (^)())handler
{
	self = [super init];
	
	if (nil != self)
	{
		self.title = title;
		self.handler = handler;
	}
	
	return self;
}

@end

@interface PWTabBar ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIView *selectedIndicatorView;
@property (nonatomic, strong) UIView *selectedHolder;

@end

@implementation PWTabBar

- (void)addItem:(PWTabBarItem *)item
{
	if (![self.items containsObject:item])
	{
		[self.items addObject:item];
		
		for (UIView *subview in [self.subviews copy])
		{
			[subview removeFromSuperview];
		}
		
		UIView *previousHolder = nil;
		for (PWTabBarItem *storedItem in self.items)
		{
			UIButton *holder = [UIButton buttonWithType:UIButtonTypeCustom];
			holder.translatesAutoresizingMaskIntoConstraints = NO;
			holder.backgroundColor = [UIColor clearColor];
			if (nil != storedItem.handler)
			{
				[holder addTarget:self action:@selector(handleSelect:)
							forControlEvents:UIControlEventTouchUpInside];
			}
			[self addSubview:holder];
			[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]"
						options:0 metrics:nil views:@{@"view" : holder}]];
			if (nil != previousHolder)
			{
				[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previous][view]"
							options:0 metrics:nil views:@{@"view" : holder, @"previous" : previousHolder}]];
			}
			else
			{
				[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]"
							options:0 metrics:nil views:@{@"view" : holder}]];
			}
			
			previousHolder = holder;
			
			[self addConstraint:[NSLayoutConstraint constraintWithItem:holder attribute:NSLayoutAttributeHeight
						relatedBy:NSLayoutRelationEqual toItem:self
						attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
			[self addConstraint:[NSLayoutConstraint constraintWithItem:holder attribute:NSLayoutAttributeWidth
						relatedBy:NSLayoutRelationEqual toItem:self
						attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0]];
			UILabel *titleLabel = [UILabel new];
			titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
			titleLabel.backgroundColor = [UIColor clearColor];
			titleLabel.text = storedItem.title;
			titleLabel.textColor = [UIColor grayColor];
            titleLabel.font = [UIFont systemFontOfSize:15];
			//[titleLabel sizeToFit];
			titleLabel.textAlignment = NSTextAlignmentCenter;
			[holder addSubview:titleLabel];
			[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
						@"H:|[view]|" options:0 metrics:nil views:@{@"view": titleLabel}]];
			[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
						@"V:|-5-[view]" options:0 metrics:nil views:@{@"view": titleLabel}]];
		}
		
		[self applySelectedIndex];
	}
}

- (NSMutableArray *)items
{
	if (nil == _items)
	{
		_items = [NSMutableArray array];
	}
	
	return _items;
}

- (UIView *)selectedIndicatorView
{
	if (nil == _selectedIndicatorView)
	{
		_selectedIndicatorView = [UIView new];
		_selectedIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
		[_selectedIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedIndicatorView
					attribute:NSLayoutAttributeHeight
					relatedBy:NSLayoutRelationEqual toItem:nil
					attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:3]];
		
		[_selectedIndicatorView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedIndicatorView
					attribute:NSLayoutAttributeWidth
					relatedBy:NSLayoutRelationEqual toItem:nil
					attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:25]];
	}
	
	return _selectedIndicatorView;
}

- (void)handleSelect:(UIButton *)sender
{
	NSUInteger index = [self.subviews indexOfObject:sender];
	if (index != NSNotFound && index != self.selectedIndex &&
				nil != [self.items[index] handler])
	{
		self.selectedIndex = index;
		((PWTabBarItem *)self.items[index]).handler();
	}
}

- (void)applySelectedIndex
{
	[self.selectedIndicatorView removeFromSuperview];
	UIView *holder = self.subviews[self.selectedIndex];
	UILabel *titleLabel = self.selectedHolder.subviews.firstObject;
	titleLabel.textColor = [UIColor grayColor];
	[holder addSubview:self.selectedIndicatorView];
	[holder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-10-|"
				options:0 metrics:nil views:@{@"view" : self.selectedIndicatorView}]];
	[holder addConstraint:[NSLayoutConstraint constraintWithItem:self.selectedIndicatorView
				attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
				toItem:holder attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
	
	titleLabel = holder.subviews.firstObject;
	titleLabel.textColor = [UIColor blackColor];
	self.selectedHolder = holder;
}

- (void)removeItemAtIndex:(NSUInteger)index
{
	if (self.items.count > index)
	{
		[self.items removeObjectAtIndex:index];
	}
}

- (void)setColorSchema:(UIColor *)colorSchema
{
	self.selectedIndicatorView.backgroundColor = colorSchema;
}

- (UIColor *)colorSchema
{
	return self.selectedIndicatorView.backgroundColor;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
	if (selectedIndex != _selectedIndex)
	{
		_selectedIndex = selectedIndex;
		[self applySelectedIndex];
	}
}

@end
