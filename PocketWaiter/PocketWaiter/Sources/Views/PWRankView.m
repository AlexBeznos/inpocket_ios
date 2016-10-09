//
//  PWRankView.m
//  PocketWaiter
//
//  Created by Www Www on 10/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRankView.h"
#import "UIColorAdditions.h"

@interface PWRankView ()

@property (nonatomic, strong) NSMutableArray<UIImageView *> *starViews;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
@property (nonatomic, strong) NSMutableArray<UIView *> *holders;

@end

@implementation PWRankView

- (void)setColorSchema:(UIColor *)colorSchema
{
	if (_colorSchema != colorSchema)
	{
		_colorSchema = colorSchema;
	}
	
	if (nil != colorSchema)
	{
		for (UIImageView *view in self.starViews)
		{
			view.tintColor = [colorSchema colorWithAlphaComponent:
						(self.rank >= [self.starViews indexOfObject:view] ? 1 : 0.2)];
		}
	}
}

- (NSMutableArray<UIView *> *)holders
{
	if (nil == _holders)
	{
		_holders = [NSMutableArray array];
	}
	
	return _holders;
}

- (NSMutableArray<UIButton *> *)buttons
{
	if (nil == _buttons)
	{
		_buttons = [NSMutableArray array];
	}
	
	return _buttons;
}

- (NSMutableArray<UIImageView *> *)starViews
{
	if (nil == _starViews)
	{
		_starViews = [NSMutableArray array];
	}
	
	return _starViews;
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
			UIView *holderView = self.holders.lastObject;
			[holderView removeFromSuperview];
			
			[self.holders removeLastObject];
			[self.starViews removeLastObject];
			[self.buttons removeLastObject];
			
			if (self.rank >= itemsCount)
			{
				self.rank = itemsCount - 1;
			}
		}
	}
	else
	{
		NSUInteger countOfViewToAdd = itemsCount -_itemsCount;
		
		for (NSInteger i = 0; i < countOfViewToAdd; i++)
		{
			UIView *holderView = [[UIView alloc]
						initWithFrame:CGRectMake(0, 0, 24, 24)];
			holderView.backgroundColor = [UIColor clearColor];
			holderView.translatesAutoresizingMaskIntoConstraints = NO;
			[holderView addConstraint:[NSLayoutConstraint
						constraintWithItem:holderView attribute:NSLayoutAttributeWidth
						relatedBy:NSLayoutRelationEqual toItem:nil
						attribute:NSLayoutAttributeNotAnAttribute multiplier:1
						constant:24]];
			[holderView addConstraint:[NSLayoutConstraint
						constraintWithItem:holderView attribute:NSLayoutAttributeHeight
						relatedBy:NSLayoutRelationEqual toItem:nil
						attribute:NSLayoutAttributeNotAnAttribute multiplier:1
						constant:24]];
			[self addSubview:holderView];
			[self.holders addObject:holderView];
			
			NSInteger offset = i * 24;
			[self addConstraints:[NSLayoutConstraint
						constraintsWithVisualFormat:@"H:|-(offset)-[view]"
						options:0 metrics:@{@"offset" : @(offset)}
						views:@{@"view" : holderView}]];
			[self addConstraint:[NSLayoutConstraint
						constraintWithItem:holderView attribute:NSLayoutAttributeCenterY
						relatedBy:NSLayoutRelationEqual toItem:self
						attribute:NSLayoutAttributeCenterY multiplier:1
						constant:0]];
			
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.backgroundColor = [UIColor clearColor];
			button.translatesAutoresizingMaskIntoConstraints = NO;
			[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
			[holderView addSubview:button];
			[holderView addConstraints:[NSLayoutConstraint
						constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view" : button}]];
			[holderView addConstraints:[NSLayoutConstraint
						constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view" : button}]];
			[self.buttons addObject:button];
			
			UIImageView *imageView = [[UIImageView alloc] initWithImage:
						[[UIImage imageNamed:@"filterAll"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
			UIColor *color = nil != self.colorSchema ?
						[self.colorSchema colorWithAlphaComponent:0.2] : [UIColor pwColorWithAlpha:0.2];
			imageView.backgroundColor = [UIColor clearColor];
			imageView.tintColor = color;
			imageView.translatesAutoresizingMaskIntoConstraints = NO;
			[holderView addSubview:imageView];
			[imageView addConstraint:[NSLayoutConstraint
						constraintWithItem:imageView attribute:NSLayoutAttributeWidth
						relatedBy:NSLayoutRelationEqual toItem:nil
						attribute:NSLayoutAttributeNotAnAttribute multiplier:1
						constant:20]];
			[imageView addConstraint:[NSLayoutConstraint
						constraintWithItem:imageView attribute:NSLayoutAttributeHeight
						relatedBy:NSLayoutRelationEqual toItem:nil
						attribute:NSLayoutAttributeNotAnAttribute multiplier:1
						constant:20]];
			[holderView addConstraint:[NSLayoutConstraint
						constraintWithItem:imageView attribute:NSLayoutAttributeCenterX
						relatedBy:NSLayoutRelationEqual toItem:holderView
						attribute:NSLayoutAttributeCenterX multiplier:1
						constant:0]];
			[holderView addConstraint:[NSLayoutConstraint
						constraintWithItem:imageView attribute:NSLayoutAttributeCenterY
						relatedBy:NSLayoutRelationEqual toItem:holderView
						attribute:NSLayoutAttributeCenterY multiplier:1
						constant:0]];
			[self.starViews addObject:imageView];
		}
		
		[self setNeedsLayout];
		[self layoutIfNeeded];
		
		_itemsCount = itemsCount;
	}
}

- (void)buttonTapped:(UIButton *)sender
{
	self.rank = [self.buttons indexOfObject:sender];
}

- (void)setRank:(NSUInteger)rank
{
	if (rank < self.starViews.count)
	{
		UIColor *color = nil != self.colorSchema ?
						self.colorSchema : [UIColor pwColorWithAlpha:1];
		for (UIImageView *view in self.starViews)
		{
			view.tintColor = [color colorWithAlphaComponent:
						(rank >= [self.starViews indexOfObject:view] ? 1 : 0.2)];
		}
	
		_rank = rank;
	}
}

@end
