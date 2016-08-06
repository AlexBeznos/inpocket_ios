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
			indicatorView.backgroundColor = [UIColor pwColorWithAlpha:0.2];
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
			
			NSInteger offset = 5 + i * 16;
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
		self.indicatorViews[_selectedItemIndex].backgroundColor =
					[UIColor pwColorWithAlpha:0.2];;
		self.indicatorViews[selectedItemIndex].backgroundColor =
					[UIColor pwColorWithAlpha:1];
	
		_selectedItemIndex = selectedItemIndex;
	}
}

@end
