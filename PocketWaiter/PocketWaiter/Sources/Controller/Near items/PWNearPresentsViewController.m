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
