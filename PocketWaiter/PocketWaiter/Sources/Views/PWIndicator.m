//
//  PWIndicator.m
//  PocketWaiter
//
//  Created by Www Www on 7/30/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////
#import "PWIndicator.h"
#import "UIColorAdditions.h"

////////////////////////////////////////////////////////////////////////////////
@interface PWIndicator ()

@property (nonatomic, strong) NSMutableArray<UIView *> *indicatorViews;

@end

////////////////////////////////////////////////////////////////////////////////
@implementation PWIndicator

- (void)setColorSchema:(UIColor *)colorSchema
{
	if (_colorSchema != colorSchema)
	{
		_colorSchema = colorSchema;
	}
	
	if (nil != colorSchema)
	{
		for (UIView *view in self.indicatorViews)
		{
			if ([self.indicatorViews indexOfObject:view] == self.selectedItemIndex)
			{
				view.backgroundColor = colorSchema;
			}
			else
			{
				view.backgroundColor = [colorSchema colorWithAlphaComponent:0.2];
			}
		}
	}
}

- (NSMutableArray<UIView *> *)indicatorViews
{
	if (nil == _indicatorViews)
	{
		_indicatorViews = [NSMutableArray array];
	}
	
	return _indicatorViews;
}

- (void)setItemsCount:(NSUInteger)itemsCount
{
	if (_itemsCount != itemsCount)
	{
		[self setupItemsWithCount:itemsCount];
	}
}

- (void)setupItemsWithCount:(NSUInteger)itemsCount
{
	if (_itemsCount > itemsCount)
	{
		NSUInteger countOfViewToDelete = _itemsCount - itemsCount;
		
		for (NSInteger i = 0; i < countOfViewToDelete; i++)
		{
			UIView *indicatorView = self.indicatorViews.lastObject;
			[indicatorView removeFromSuperview];
			[self.indicatorViews removeObject:indicatorView];
			
			if (self.selectedItemIndex >= itemsCount)
			{
				self.selectedItemIndex = itemsCount - 1;
			}
		}
	}
	else
	{
		NSUInteger countOfViewToAdd = itemsCount -_itemsCount;
		
		for (NSInteger i = 0; i < countOfViewToAdd; i++)
		{
			UIView *indicatorView = [[UIView alloc]
						initWithFrame:CGRectMake(0, 0, 6, 6)];
			UIColor *color = nil != self.colorSchema ?
						[self.colorSchema colorWithAlphaComponent:0.2] : [UIColor pwColorWithAlpha:0.2];
			indicatorView.backgroundColor = color;
			indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
			[indicatorView addConstraint:[NSLayoutConstraint
						constraintWithItem:indicatorView attribute:NSLayoutAttributeWidth
						relatedBy:NSLayoutRelationEqual toItem:nil
						attribute:NSLayoutAttributeNotAnAttribute multiplier:1
						constant:6]];
			[indicatorView addConstraint:[NSLayoutConstraint
						constraintWithItem:indicatorView attribute:NSLayoutAttributeHeight
						relatedBy:NSLayoutRelationEqual toItem:nil
						attribute:NSLayoutAttributeNotAnAttribute multiplier:1
						constant:6]];
			[self addSubview:indicatorView];
			
			NSInteger offset = 5 + i * 11;
			[self addConstraints:[NSLayoutConstraint
						constraintsWithVisualFormat:@"H:|-(offset)-[indicatorView]"
						options:0 metrics:@{@"offset" : @(offset)}
						views:@{@"indicatorView" : indicatorView}]];
			[self addConstraint:[NSLayoutConstraint
						constraintWithItem:indicatorView attribute:NSLayoutAttributeCenterY
						relatedBy:NSLayoutRelationEqual toItem:self
						attribute:NSLayoutAttributeCenterY multiplier:1
						constant:0]];
			[self.indicatorViews addObject:indicatorView];
		}
		
		[self setNeedsLayout];
		[self layoutIfNeeded];
		
		_itemsCount = itemsCount;
	}
}

- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex
{
	if (selectedItemIndex < self.indicatorViews.count)
	{
		UIColor *color = nil != self.colorSchema ?
						self.colorSchema : [UIColor pwColorWithAlpha:1];
		self.indicatorViews[_selectedItemIndex].backgroundColor =
					[color colorWithAlphaComponent:0.2];
		self.indicatorViews[selectedItemIndex].backgroundColor = color;
	
		_selectedItemIndex = selectedItemIndex;
	}
}

@end
