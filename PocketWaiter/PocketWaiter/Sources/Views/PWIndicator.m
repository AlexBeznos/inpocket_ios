//
//  PWIndicator.m
//  PocketWaiter
//
//  Created by Www Www on 7/30/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////
#import "PWIndicator.h"

////////////////////////////////////////////////////////////////////////////////
@interface PWIndicator ()

@property (nonatomic, strong) NSMutableArray<UIImageView *> *indicatorViews;

@end

////////////////////////////////////////////////////////////////////////////////
@implementation PWIndicator

- (NSMutableArray<UIImageView *> *)indicatorViews
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
			UIImageView *indicatorView = self.indicatorViews.lastObject;
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
			UIImageView *indicatorView = [[UIImageView alloc]
						initWithImage:[UIImage imageNamed:@"normal"]];
			indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
			[indicatorView sizeToFit];
			
			// todo: add constraint layout
			[self addSubview:indicatorView];
		}
		
		_itemsCount = itemsCount;
	}
}

- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex
{
	if (selectedItemIndex < self.indicatorViews.count)
	{
		self.indicatorViews[_selectedItemIndex].image = [UIImage imageNamed:@"normal"];
		self.indicatorViews[selectedItemIndex].image = [UIImage imageNamed:@"selected"];
	
		_selectedItemIndex = selectedItemIndex;
	}
}

@end
