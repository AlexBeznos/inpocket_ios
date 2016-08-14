//
//  PWDetailedNearPresentsController.m
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWDetailedNearPresentsController.h"
#import "PWPresentProduct.h"
#import "PWNearItemCollectionViewCell.h"

@interface PWDetailedNearPresentsController ()

@property (nonatomic, strong) NSArray<PWPresentProduct *> *presents;

@end

@implementation PWDetailedNearPresentsController

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
	
	cell.placeName = @"Vapiano";
	cell.placeDistance = @"2 km";
	cell.image = present.icon;
	cell.descriptionTitle = present.name;
	cell.buttonTitle = @"Poluchit'";
}

- (NSArray *)contentItems
{
	return self.presents;
}

- (NSString *)navigationTitle
{
	return @"Подарки рядом";
}

@end