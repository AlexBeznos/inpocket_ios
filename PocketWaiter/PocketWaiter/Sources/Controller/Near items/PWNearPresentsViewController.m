//
//  PWNearPresentsViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWNearPresentsViewController.h"
#import "PWModelManager.h"
#import "PWNearItemCollectionViewCell.h"
#import "PWDetailesPresentsViewController.h"
#import "PWImageView.h"

@interface PWNearPresentsViewController ()

@property (strong, nonatomic) NSArray<PWPresentProduct *> *presents;

@end

@implementation PWNearPresentsViewController

- (instancetype)initWithPresents:(NSArray<PWPresentProduct *> *)presents
			scrollHandler:(void (^)(CGPoint velocity))aHandler
			transiter:(id<IPWTransiter>)transiter
{
	self = [super initWithScrollHandler:aHandler transiter:transiter];
	
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

- (PWDetailesItemsViewController *)allItemsController
{
	PWDetailesPresentsViewController *controller =
				[[PWDetailesPresentsViewController alloc]
				initWithPresents:self.presents];
	
	return controller;
}

- (NSString *)titleDescription
{
	return @"Подарки рядом";
}

@end
