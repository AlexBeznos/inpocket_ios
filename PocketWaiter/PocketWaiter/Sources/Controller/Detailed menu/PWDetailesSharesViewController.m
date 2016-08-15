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
{
	self = [super init];
	
	if (nil != self)
	{
		self.shares = shares;
	}
	
	return self;
}

- (void)retrieveModelAndSetupInitialController
{
	__weak __typeof(self) weakSelf = self;
	[[PWModelManager sharedManager] getSharesWithCount:10 offset:0
				completion:^(NSArray<PWRestaurantShare *> *shares)
	{
		weakSelf.shares = shares;
		
		[weakSelf setupContentWithMode:0];
	}];
}

- (PWDetailedNearItemsCollectionController *)createListController
{
	return [[PWDetailedNearSharesCollectionController alloc]
					initWithShares:self.shares];
}

- (PWMapController *)createMapController
{
	return [[PWSharesMapController alloc] initWithShares:self.shares
					selectedShare:self.shares.firstObject];
}

- (NSString *)navigationTitle
{
	return @"Акции рядом";
}

@end
