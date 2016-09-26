//
//  PWRestaurantsViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRestaurantsViewController.h"
#import "PWRestaurantsCollectionController.h"
#import "PWTabBar.h"
#import "PWModelManager.h"
#import "UIViewControllerAdditions.h"
#import "UIColorAdditions.h"
#import "PWRestaurantFilterController.h"
#import "PWEnums.h"
#import "PWMapController.h"
#import "PWRestaurantMapController.h"

@interface PWRestaurantsViewController ()

@property (strong, nonatomic) IBOutlet PWTabBar *tapper;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) PWRestaurantFilterController *filterController;
@property (nonatomic) PWRestaurantType filter;

@property (nonatomic, strong) PWRestaurantsCollectionController *listController;
@property (nonatomic, strong) PWRestaurantMapController *mapController;
@property (nonatomic, strong) UIViewController *currentController;

@property (nonatomic, strong) NSArray<PWRestaurant *> *filteredRestaurants;

@property (nonatomic) BOOL isCollectionMode;

@end

@implementation PWRestaurantsViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.filter = kPWRestaurantTypeAll;
	
	__weak __typeof(self) weakSelf = self;
	
	self.containerView.backgroundColor = [UIColor pwBackgroundColor];
	PWTabBarItem *list = [[PWTabBarItem alloc] initWithTitle:@"СПИСОК" handler:
	^{
		[weakSelf setupContentWithMode:0];
	}];
	PWTabBarItem *map = [[PWTabBarItem alloc] initWithTitle:@"КАРТА" handler:
	^{
		[weakSelf setupContentWithMode:1];
	}];
	
	[self.tapper addItem:list];
	[self.tapper addItem:map];
	self.tapper.colorSchema = [UIColor blackColor];
	
	[self startActivity];
	[[PWModelManager sharedManager] getRestaurantsWithCount:10 offset:0
				completion:^(NSArray<PWRestaurant *> *restaurants, NSError *error)
	{
		weakSelf.filteredRestaurants = restaurants;
		
		[weakSelf setupContentWithMode:0];
		[weakSelf stopActivity];
	}];
}

- (void)setupContentWithMode:(NSUInteger)mode
{
	[self.currentController.view removeFromSuperview];
	[self.currentController removeFromParentViewController];
	
	if (0 == mode)
	{
		self.listController = [[PWRestaurantsCollectionController alloc]
					initWithRestaurants:self.filteredRestaurants transiter:self];
		self.currentController = self.listController;
	}
	else
	{
		self.mapController = [[PWRestaurantMapController alloc]
					initWithRestaurants:self.filteredRestaurants
					selectedRestaurant:self.filteredRestaurants.firstObject transiter:self];
		self.currentController = self.mapController;
	}
	
	[self addChildViewController:self.currentController];
	[self.containerView addSubview:self.currentController.view];
	[self.currentController didMoveToParentViewController:self];
	self.currentController.view.translatesAutoresizingMaskIntoConstraints = NO;
	[self.containerView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : self.currentController.view}]];
	[self.containerView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : self.currentController.view}]];
	
	CGFloat aspectRatio = CGRectGetWidth(self.parentViewController.
					view.frame) / 320.;
	if (0 == mode)
	{
		[self.listController setContentSize:CGSizeMake(320 * aspectRatio, 90)];
	}
	else
	{
		[self.mapController setContentSize:CGSizeMake(320 * aspectRatio,
					95 * aspectRatio)];
	}
}

- (void)setupNavigation
{
	[super setupNavigation];
	
	UIButton *theFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[theFilterButton setImage:[UIImage imageNamed:@"blackFilter"]
				forState:UIControlStateNormal];
	[theFilterButton addTarget:self action:@selector(showFilter)
				forControlEvents:UIControlEventTouchUpInside];
	[theFilterButton sizeToFit];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
				initWithCustomView:theFilterButton];
}

- (NSString *)name
{
	return @"Заведения";
}

- (void)showFilter
{
	__weak __typeof(self) weakSelf = self;
	self.filterController = [[PWRestaurantFilterController alloc]
				initWithCurrentFilter:self.filter
				typeHandler:^(PWRestaurantType type)
	{
		weakSelf.filter = type;
	}];
	
	[self performForwardTransition:self.filterController];
}

@end
