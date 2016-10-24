//
//  PWNearSharesViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWSharesViewController.h"
#import "PWModelManager.h"
#import "PWNearItemCollectionViewCell.h"
#import "PWDetailesSharesViewController.h"
#import "PWShareViewController.h"
#import "PWIndicator.h"
#import "PWImageView.h"

@interface PWNearItemsViewController (Protected)

@property (nonatomic) PWIndicator *indicator;
- (void)setupIndicator;

@end

@interface PWSharesViewController ()

@property (strong, nonatomic) NSArray<PWRestaurantShare *> *shares;
@property (nonatomic, strong) NSString *preferredTitle;

@end

@implementation PWSharesViewController

- (instancetype)initWithShares:(NSArray<PWRestaurantShare *> *)shares
			title:(NSString *)title
			scrollHandler:(void (^)(CGPoint velocity))aHandler
			transiter:(id<IPWTransiter>)transiter
{
	self = [super initWithScrollHandler:aHandler transiter:transiter];
	
	if (nil != self)
	{
		self.shares = shares;
		self.preferredTitle = title;
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
	
	cell.placeName = share.ownerName;
	cell.placeDistance = share.distance;
	cell.descriptionTitle = share.shareDescription;
	cell.buttonTitle = @"Подробнее";
	cell.colorScheme = self.colorScheme;
	cell.deleteDescriptionView = [self.preferredTitle isEqualToString:@"Акции"];
	
	if (nil == share.image)
	{
		NSURL *iconURL = [NSURL URLWithString:share.imagePath];
		[cell.imageView downloadImageFromURL:iconURL completion:
		^(NSURL *localURL)
		{
			share.downloadedImagePath = localURL.path;
		}];
	}
	else
	{
		cell.imageView.image = share.image;
	}
}

- (PWDetailesItemsViewController *)allItemsController
{
	PWDetailesSharesViewController *controller =
				[[PWDetailesSharesViewController alloc]
				initWithShares:self.shares
				listOnly:[self.preferredTitle isEqualToString:@"Акции"]];
	
	return controller;
}

- (NSArray *)contentItems
{
	return self.shares;
}

- (NSString *)titleDescription
{
	return nil == self.preferredTitle ? @"Акции рядом" : self.preferredTitle;
}

- (void)presentDetailsForItemAtIndex:(NSUInteger)index
{
	PWShareViewController *shareController =
				[[PWShareViewController alloc] initWithShare:self.shares[index]];
	[self.transiter performForwardTransition:shareController];
}

@end
