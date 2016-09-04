//
//  PWDetailedRestaurantsViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWDetailedRestaurantsViewController.h"
#import "PWRestaurantMapController.h"
#import "PWRestaurantsCollectionController.h"
#import "PWRestaurant.h"
#import "PWModelManager.h"

@interface PWDetailesItemsViewController ()

- (void)setupContentWithMode:(NSUInteger)mode;

@end

@interface PWDetailedRestaurantsViewController ()

@property (strong, nonatomic) NSArray<PWRestaurant *> *restaurants;

@end

@implementation PWDetailedRestaurantsViewController

- (instancetype)initWithRestaurants:(NSArray<PWRestaurant *> *)restaurants
{
	self = [super init];
	
	if (nil != self)
	{
		self.restaurants = restaurants;
	}
	
	return self;
}

- (void)retrieveModelAndSetupInitialControllerWithCompletion:
			(void (^)())aCompletion
{
	__weak __typeof(self) weakSelf = self;
	[[PWModelManager sharedManager] getRestaurantsWithCount:10 offset:0
				completion:^(NSArray<PWRestaurant *> *restaurants, NSError *error)
	{
		weakSelf.restaurants = restaurants;
		
		[weakSelf setupContentWithMode:0];
		if (nil != aCompletion)
		{
			aCompletion();
		}
	}];
}

- (PWDetailedNearItemsCollectionController *)createListController
{
	return [[PWRestaurantsCollectionController alloc]
					initWithRestaurants:self.restaurants];;
}

- (PWMapController *)createMapController
{
	return [[PWRestaurantMapController alloc]
					initWithRestaurants:self.restaurants
					selectedRestaurant:self.restaurants.firstObject];
}

- (NSString *)navigationTitle
{
	return @"Заведения рядом";
}

@end
