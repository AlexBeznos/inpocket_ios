//
//  PWDetailedNearPresentsCollectionController.m
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWDetailedNearPresentsCollectionController.h"
#import "PWPresentProduct.h"
#import "PWNearItemCollectionViewCell.h"

@interface PWDetailedNearPresentsCollectionController ()

@property (nonatomic, strong) NSArray<PWPresentProduct *> *presents;

@end

@implementation PWDetailedNearPresentsCollectionController

- (instancetype)initWithPresents:(NSArray<PWPresentProduct *> *)presents
{
	self = [super init];
	
	if (nil != self)
	{
		self.presents = presents;
	}
	
	return self;
}

- (void)setupCell:(PWNearItemCollectionViewCell *)cell
			forItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWPresentProduct *present = self.presents[indexPath.row];
	
	cell.placeName = present.restaurant.name;
	cell.placeDistance = @"2 km";
	cell.image = present.icon;
	cell.descriptionTitle = present.name;
	cell.buttonTitle = @"Получить";
}

- (NSArray *)contentItems
{
	return self.presents;
}

@end