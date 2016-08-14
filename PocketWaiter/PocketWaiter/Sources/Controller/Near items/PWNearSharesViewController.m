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
#import "PWDetailedNearSharesController.h"

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
	
	cell.placeName = @"Vapiano";
	cell.placeDistance = @"2 km";
	cell.image = share.image;
	cell.descriptionTitle = share.shareDescription;
	cell.buttonTitle = @"Podrobnee'";
}

- (PWDetailedNearItemsController *)allItemsController
{
	PWDetailedNearItemsController *controller =
				[[PWDetailedNearSharesController alloc]
				initWithShares:self.shares];
	
	[controller setContentSize:self.contentSize];
	
	return controller;
}

- (NSArray *)contentItems
{
	return self.shares;
}

- (NSString *)titleDescription
{
	return @"Actsii ryadom";
}

@end
