//
//  PWDetailedNearSharesCollectionController.m
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWDetailedNearSharesCollectionController.h"
#import "PWNearItemCollectionViewCell.h"
#import "PWRestaurantShare.h"

@interface PWDetailedNearSharesCollectionController ()

@property (nonatomic, strong) NSArray<PWRestaurantShare *> *shares;

@end

@implementation PWDetailedNearSharesCollectionController

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
	
	cell.placeName = share.restaurant.name;
	cell.placeDistance = @"2 km";
	cell.image = share.image;
	cell.descriptionTitle = share.shareDescription;
	cell.buttonTitle = @"Подробнее";
}

- (NSArray *)contentItems
{
	return self.shares;
}

@end