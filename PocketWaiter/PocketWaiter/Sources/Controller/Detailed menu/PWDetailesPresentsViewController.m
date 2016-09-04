//
//  PWDetailesPresentsViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWDetailesPresentsViewController.h"
#import "PWPresentProduct.h"
#import "PWModelManager.h"
#import "PWDetailedNearPresentsCollectionController.h"
#import "PWPresentsMapController.h"

@interface PWDetailesItemsViewController ()

- (void)setupContentWithMode:(NSUInteger)mode;

@end

@interface PWDetailesPresentsViewController ()

@property (nonatomic, strong) NSArray<PWPresentProduct *> *presents;

@end

@implementation PWDetailesPresentsViewController

- (instancetype)initWithPresents:(NSArray<PWPresentProduct *> *)presents
{
	self = [super init];
	
	if (nil != self)
	{
		self.presents = presents;
	}
	
	return self;
}

- (void)retrieveModelAndSetupInitialControllerWithCompletion:
			(void (^)())aCompletion
{
	__weak __typeof(self) weakSelf = self;
	[[PWModelManager sharedManager] getPresentsWithCount:10 offset:0
				completion:^(NSArray<PWPresentProduct *> *presents, NSError *error)
	{
		if (nil == error)
		{
			weakSelf.presents = presents;
			
			[weakSelf setupContentWithMode:0];
			
			if (nil != aCompletion)
			{
				aCompletion();
			}
		}
		else
		{
		
		}
	}];
}

- (PWDetailedNearItemsCollectionController *)createListController
{
	return [[PWDetailedNearPresentsCollectionController alloc]
					initWithPresents:self.presents];
}

- (PWMapController *)createMapController
{
	return [[PWPresentsMapController alloc] initWithPresents:self.presents
					selectedPresent:self.presents.firstObject];
}

- (NSString *)navigationTitle
{
	return @"Подарки рядом";
}

@end
