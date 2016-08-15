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

@interface PWNearPresentsViewController ()

@property (strong, nonatomic) NSArray<PWPresentProduct *> *presents;

@end

@implementation PWNearPresentsViewController

- (void)viewDidLoad
{
	self.presents = [[PWModelManager sharedManager] nearPresents];
	
	[super viewDidLoad];
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

- (PWDetailesItemsViewController *)allItemsController
{
	PWDetailesPresentsViewController *controller =
				[[PWDetailesPresentsViewController alloc]
				initWithPresents:self.presents];
//	
//	[controller setContentSize:self.contentSize];
	
	return controller;
}

- (NSString *)titleDescription
{
	return @"Подарки рядом";
}

@end
