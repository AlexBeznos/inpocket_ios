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

@interface PWNearSharesViewController ()

@property (strong, nonatomic) NSArray<PWRestaurantShare *> *shares;

@end

@implementation PWNearSharesViewController

- (void)viewDidLoad
{
	self.shares = [[PWModelManager sharedManager] nearShares];
	
	[super viewDidLoad];
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
