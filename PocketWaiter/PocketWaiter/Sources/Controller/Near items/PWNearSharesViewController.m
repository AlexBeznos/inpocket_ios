//
//  PWNearSharesViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWNearSharesViewController.h"
#import "PWModelManager.h"
#import "PWNearItemCollectionViewCell.h"
#import "PWDetailesSharesViewController.h"
#import "PWShareViewController.h"
#import "PWIndicator.h"

@interface PWNearItemsViewController (Protected)

@property (nonatomic) PWIndicator *indicator;
- (void)setupIndicator;

@end

@interface PWNearSharesViewController ()

@property (strong, nonatomic) NSArray<PWRestaurantShare *> *shares;

@end

@implementation PWNearSharesViewController

- (instancetype)initWithShares:(NSArray<PWRestaurantShare *> *)shares
			scrollHandler:(void (^)(CGPoint velocity))aHandler
			transiter:(id<IPWTransiter>)transiter
{
	self = [super initWithScrollHandler:aHandler transiter:transiter];
	
	if (nil != self)
	{
		self.shares = shares;
	}
	
	return self;
}

- (void)setColorScheme:(UIColor *)colorScheme
{
	if (_colorScheme != colorScheme)
	{
		_colorScheme = colorScheme;
	}
	self.indicator.colorSchema = colorScheme;
}

- (void)setupIndicator
{
	[super setupIndicator];
	
	self.indicator.colorSchema = self.colorScheme;
}

- (void)setupCell:(PWNearItemCollectionViewCell *)cell
			forItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWRestaurantShare *share = self.shares[indexPath.row];
	
	cell.placeName = share.restaurant.name;
	cell.placeDistance = @"2 km";
	cell.image = share.image;
	cell.descriptionTitle = share.shareDescription;
	cell.buttonTitle = @"Подробнее";
	cell.colorScheme = self.colorScheme;
}

- (PWDetailesItemsViewController *)allItemsController
{
	PWDetailesSharesViewController *controller =
				[[PWDetailesSharesViewController alloc]
				initWithShares:self.shares];
	
	return controller;
}

- (NSArray *)contentItems
{
	return self.shares;
}

- (NSString *)titleDescription
{
	return @"Акции рядом";
}

- (void)presentDetailsForItemAtIndex:(NSUInteger)index
{
	PWShareViewController *shareController =
				[[PWShareViewController alloc] initWithShare:self.shares[index]];
	[self.transiter performForwardTransition:shareController];
}

@end
