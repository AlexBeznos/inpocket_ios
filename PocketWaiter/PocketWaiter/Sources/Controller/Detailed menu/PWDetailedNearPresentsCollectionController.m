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
#import "PWImageView.h"

@interface PWDetailedNearPresentsCollectionController ()

@property (nonatomic, strong) NSArray<PWPresentProduct *> *presents;

@end

@implementation PWDetailedNearPresentsCollectionController

- (instancetype)initWithPresents:(NSArray<PWPresentProduct *> *)presents
			transiter:(id<IPWTransiter>)transiter
{
	self = [super initWithTransiter:transiter];
	
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
	
	cell.placeName = present.ownerName;
	cell.placeDistance = present.distance;
	cell.descriptionTitle = present.name;
	cell.buttonTitle = @"Получить";
	
	if (nil == present.icon)
	{
		NSURL *iconURL = [NSURL URLWithString:present.iconPath];
		[cell.imageView downloadImageFromURL:iconURL completion:
		^(NSURL *localURL)
		{
			present.downloadedIconPath = localURL.path;
		}];
	}
	else
	{
		cell.imageView.image = present.icon;
	}
}

- (NSArray *)contentItems
{
	return self.presents;
}

@end
