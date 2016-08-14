//
//  PWDetailedNearSharesController.m
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWDetailedNearSharesController.h"
#import "PWNearItemCollectionViewCell.h"
#import "PWRestaurantShare.h"

@interface PWDetailedNearSharesController ()

@property (nonatomic, strong) NSArray<PWRestaurantShare *> *shares;

@end

@implementation PWDetailedNearSharesController

- (instancetype)initWithShares:(NSArray<PWRestaurantShare *> *)shares
{
	self = [super init];
	
	if (nil != self)
	{
		self.shares = shares;
	}
	
	return self;
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

- (NSArray *)contentItems
{
	return self.shares;
}

- (NSString *)navigationTitle
{
	return @"Акции рядом";
}

@end
