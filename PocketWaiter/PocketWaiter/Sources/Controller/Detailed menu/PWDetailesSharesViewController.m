//
//  PWDetailesSharesViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWDetailesSharesViewController.h"
#import "PWRestaurantShare.h"
#import "PWModelManager.h"
#import "PWDetailedNearSharesCollectionController.h"
#import "PWSharesMapController.h"

@interface PWDetailesItemsViewController ()

- (void)setupContentWithMode:(NSUInteger)mode;

@end

@interface PWDetailesSharesViewController ()

@property (nonatomic, strong) NSArray<PWRestaurantShare *> *shares;

@end

@implementation PWDetailesSharesViewController

- (instancetype)initWithShares:(NSArray<PWRestaurantShare *> *)shares
			listOnly:(BOOL)listOnly
{
	self = [super initWithListModeOnly:listOnly];
	
	if (nil != self)
	{
		self.shares = shares;
	}
	
	return self;
}

- (void)retrieveModelAndSetupInitialControllerWithCompletion:
			(void (^)())aCompletion
{
	__weak __typeof(self) weakSelf = self;
	[[PWModelManager sharedManager] getSharesWithCount:10 offset:0
				completion:^(NSArray<PWRestaurantShare *> *shares, NSError *error)
	{
		weakSelf.shares = shares;
		
		[weakSelf setupContentWithMode:0];
		
		if (nil != aCompletion)
		{
			aCompletion();
		}
	}];
}

- (PWDetailedNearItemsCollectionController *)createListController
{
	return [[PWDetailedNearSharesCollectionController alloc]
					initWithShares:self.shares transiter:self.transiter];
}

- (PWMapController *)createMapController
{
	return [[PWSharesMapController alloc] initWithShares:self.shares
					selectedShare:self.shares.firstObject transiter:self.transiter];
}

- (NSString *)navigationTitle
{
	return @"Акции рядом";
}

@end
