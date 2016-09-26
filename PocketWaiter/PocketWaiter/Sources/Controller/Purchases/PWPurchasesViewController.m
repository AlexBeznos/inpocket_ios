//
//  PWPurchasesViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWPurchasesViewController.h"
#import "PWModelManager.h"
#import "UIColorAdditions.h"
#import "PWNoPurchasesViewController.h"
#import "PWAllPurchasesViewController.h"

@interface PWPurchasesViewController ()

@property (nonatomic, strong) NSArray<PWRestaurant *> *restaurants;
@property (nonatomic, strong) PWUser *user;
@property (nonatomic, strong) PWNoPurchasesViewController *noPurchasesController;
@property (nonatomic, strong) PWAllPurchasesViewController *allPurchasesController;

@end

@implementation PWPurchasesViewController

@synthesize transiter;

- (instancetype)initWithUser:(PWUser *)user restaurants:(NSArray *)restaurants
{
	self = [super init];
	
	if (nil != self)
	{
		self.user = user;
		self.restaurants = restaurants;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	
	__weak __typeof(self) theWeakSelf = self;
	
	if (nil == self.restaurants)
	{
		[self startActivity];
		
		[[PWModelManager sharedManager] getPurchasesRestaurantsForUser:self.user
					withCount:5 offset:0 completion:^(NSArray<PWRestaurant *> *restaurants, NSError *error)
		{
			theWeakSelf.restaurants = restaurants;
			[theWeakSelf stopActivity];
			
			if (0 == restaurants.count)
			{
				[theWeakSelf setupController:theWeakSelf.noPurchasesController];
			}
			else
			{
				PWAllPurchasesViewController *allPurchasesController =
							[[PWAllPurchasesViewController alloc]
							initWithUser:theWeakSelf.user restaurants:restaurants
							transiter:self.transiter];
				theWeakSelf.allPurchasesController = allPurchasesController;
				[theWeakSelf setupController:theWeakSelf.allPurchasesController];
				CGFloat aspectRatio = CGRectGetWidth(theWeakSelf.parentViewController.
							view.frame) / 320.;
				[allPurchasesController setWidth:320 * aspectRatio];
			}
		}];
	}
	else
	{
		PWAllPurchasesViewController *allPurchasesController =
					[[PWAllPurchasesViewController alloc]
					initWithUser:theWeakSelf.user restaurants:self.restaurants
					transiter:self.transiter];
		theWeakSelf.allPurchasesController = allPurchasesController;
		[theWeakSelf setupController:theWeakSelf.allPurchasesController];
		CGFloat aspectRatio = CGRectGetWidth(theWeakSelf.parentViewController.
					view.frame) / 320.;
		[allPurchasesController setWidth:320 * aspectRatio];
	}
}

- (void)setupController:(UIViewController *)controller
{
	[self addChildViewController:controller];
	[self.view addSubview:controller.view];
	[controller didMoveToParentViewController:self];
	controller.view.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : controller.view}]];
	[self.view addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : controller.view}]];
}

- (PWNoPurchasesViewController *)noPurchasesController
{
	if (nil == _noPurchasesController)
	{
		_noPurchasesController = [PWNoPurchasesViewController new];
		_noPurchasesController.view.translatesAutoresizingMaskIntoConstraints = NO;
	}
	
	return _noPurchasesController;
}

- (void)setupWithNavigationItem:(UINavigationItem *)item
{
	[self setupBackItemWithTarget:self action:@selector(transitionBack)
				navigationItem:item];
	
	UILabel *theTitleLabel = [UILabel new];
	theTitleLabel.text = @"Бонусы";
	theTitleLabel.font = [UIFont systemFontOfSize:20];
	[theTitleLabel sizeToFit];
	
	item.leftBarButtonItems = @[item.leftBarButtonItem,
				[[UIBarButtonItem alloc] initWithCustomView:theTitleLabel]];
	item.rightBarButtonItems = nil;
}

- (void)transitionBack
{
	[self.transiter performBackTransition];
}

@end
