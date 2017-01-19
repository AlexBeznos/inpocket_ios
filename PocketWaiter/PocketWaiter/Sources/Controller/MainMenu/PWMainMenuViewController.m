//
//  PWMainMenuViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWMainMenuViewController.h"
#import "UIViewControllerAdditions.h"
#import "PWNearPresentsViewController.h"
#import "PWSharesViewController.h"
#import "PWNearRestaurantsViewController.h"
#import "PWPurchasesViewController.h"
#import "PWModelManager.h"
#import "PWLocationManager.h"
#import "PWModalController.h"
#import "PWNoConnectionAlertController.h"

@interface PWScrollableViewController ()

- (void)handleVelocity:(CGPoint)velocity;

@end

@interface PWMainMenuViewController ()

@property (nonatomic, strong) PWLocationManager *locationManager;
@property (nonatomic, strong) PWModalController *locationDialog;

@end

@implementation PWMainMenuViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	__weak __typeof(self) weakSelf = self;
	
	self.locationManager = [PWLocationManager new];
	[self startActivity];
	[self.locationManager getCurrentLocationWithCompletion:
	^(CLLocation *location, NSError *error)
	{
		if (nil != error)
		{
			[weakSelf stopActivity];
			[weakSelf showNoAccessLocation];
		}
		else
		{
			[[PWModelManager sharedManager] getNearItemsWithCount:6
						location:location completion:
			^(NSArray<PWRestaurant *> *nearRestaurant,
						NSArray<PWRestaurantShare *> *nearShares,
						NSArray<PWPresentProduct *> *nearPresents, NSError *error)
			{
				[weakSelf stopActivity];
				if (nil == error)
				{
					[weakSelf showNearRestaurants:nearRestaurant shares:nearShares
								presents:nearPresents];
				}
				else
				{
					[weakSelf showNoInternetDialog];
				}
			}];
		}
	}];
}

- (void)showNoAccessLocation
{
	__weak __typeof(self) weakSelf = self;
	PWNoConnectionAlertController *alert = [[PWNoConnectionAlertController alloc]
				initWithType:kPWConnectionTypeLocation retryAction:
	^{
		[weakSelf resumeActivity];
	}];
	self.locationDialog = [[PWModalController alloc]
				initWithContentController:alert autoDismiss:NO];
	[self.locationDialog showWithCompletion:nil];
}

- (void)showNearRestaurants:(NSArray<PWRestaurant *> *)restaurants
			shares:(NSArray<PWRestaurantShare *> *)shares
			presents:(NSArray<PWPresentProduct *> *)presents
{
	CGFloat aspectRatio = CGRectGetWidth(self.parentViewController.view.frame) / 320.;
	__weak __typeof(self) weakSelf = self;
	
	CGFloat estimatedHeight = 0;
	
	UIView *previousView = nil;
	
	if (0 != presents.count)
	{
		PWNearPresentsViewController *nearPresentsController =
					[[PWNearPresentsViewController alloc] initWithPresents:presents
					scrollHandler:^(CGPoint velocity)
		{
			[weakSelf handleVelocity:velocity];
		}
					transiter:self];
		
		[self addChildViewController:nearPresentsController];
		[self.scrollView addSubview:nearPresentsController.view];
		
		[nearPresentsController didMoveToParentViewController:self];
		nearPresentsController.view.translatesAutoresizingMaskIntoConstraints = NO;
		
		[self.scrollView addConstraints:[NSLayoutConstraint
					constraintsWithVisualFormat:@"V:|[view]"
					options:0 metrics:nil
					views:@{@"view" : nearPresentsController.view}]];
		[self.scrollView addConstraints:[NSLayoutConstraint
					constraintsWithVisualFormat:@"H:|[view]"
					options:0 metrics:nil
					views:@{@"view" : nearPresentsController.view}]];
		
		nearPresentsController.contentSize =
					CGSizeMake(320 * aspectRatio, 420 * aspectRatio);
		estimatedHeight +=  420 * aspectRatio;
		previousView = nearPresentsController.view;
	}
	
	if (0 != shares.count)
	{
		PWSharesViewController *nearSharesController =
					[[PWSharesViewController alloc] initWithShares:shares title:nil
					scrollHandler:^(CGPoint velocity)
		{
			[weakSelf handleVelocity:velocity];
		}
					transiter:self];

		[self addChildViewController:nearSharesController];
		[self.scrollView addSubview:nearSharesController.view];
		
		[nearSharesController didMoveToParentViewController:self];
		nearSharesController.view.translatesAutoresizingMaskIntoConstraints = NO;
		
		if (nil != previousView)
		{
			[self.scrollView addConstraint:[NSLayoutConstraint
						constraintWithItem:nearSharesController.view
						attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
						toItem:previousView
						attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
		}
		else
		{
			[self.scrollView addConstraints:[NSLayoutConstraint
						constraintsWithVisualFormat:@"V:|[view]"
						options:0 metrics:nil
						views:@{@"view" : nearSharesController.view}]];
		}
		
		[self.scrollView addConstraints:[NSLayoutConstraint
					constraintsWithVisualFormat:@"H:|[view]"
					options:0 metrics:nil
					views:@{@"view" : nearSharesController.view}]];
		
		nearSharesController.contentSize =
					CGSizeMake(320 * aspectRatio, 420 * aspectRatio);
		estimatedHeight += 420 * aspectRatio;
		previousView = nearSharesController.view;
	}
	
	if (0 != restaurants.count)
	{
		PWNearRestaurantsViewController *nearRestaurantsController =
					[[PWNearRestaurantsViewController alloc] initWithRestaurants:restaurants
					scrollHandler:^(CGPoint velocity)
		{
			[weakSelf handleVelocity:velocity];
		}
					transiter:self];
		
		[self addChildViewController:nearRestaurantsController];
		[self.scrollView addSubview:nearRestaurantsController.view];
		
		[nearRestaurantsController didMoveToParentViewController:self];
		nearRestaurantsController.view.translatesAutoresizingMaskIntoConstraints = NO;
		
		if (nil != previousView)
		{
			[self.scrollView addConstraint:[NSLayoutConstraint
					constraintWithItem:nearRestaurantsController.view
					attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
					toItem:previousView
					attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
		}
		else
		{
			[self.scrollView addConstraints:[NSLayoutConstraint
						constraintsWithVisualFormat:@"V:|[view]"
						options:0 metrics:nil
						views:@{@"view" : nearRestaurantsController.view}]];
		}
		
		[self.scrollView addConstraints:[NSLayoutConstraint
					constraintsWithVisualFormat:@"H:|[view]"
					options:0 metrics:nil
					views:@{@"view" : nearRestaurantsController.view}]];
		
		CGFloat estimatedRestaurantsHeight = nearRestaurantsController.fixedContentSpace +
					aspectRatio * nearRestaurantsController.resizableContentSpace + 20;
		nearRestaurantsController.contentSize =
					CGSizeMake(320 * aspectRatio, estimatedRestaurantsHeight);
		estimatedHeight += estimatedRestaurantsHeight;
	}
	
	self.scrollView.contentSize = CGSizeMake(320 * aspectRatio, estimatedHeight);
}

- (NSString *)name
{
	return @"InPocket";
}

- (void)setupNavigation
{
	[super setupNavigation];
	
	UIButton *theBonusesButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[theBonusesButton setImage:[UIImage imageNamed:@"collectedBonus"]
				forState:UIControlStateNormal];
	[theBonusesButton addTarget:self action:@selector(showBonuses)
				forControlEvents:UIControlEventTouchUpInside];
	[theBonusesButton sizeToFit];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
				initWithCustomView:theBonusesButton];
}

- (void)showBonuses
{
	PWPurchasesViewController *controller = [[PWPurchasesViewController alloc]
				initWithUser:[[PWModelManager sharedManager] registeredUser]
				restaurants:nil];
	[self performForwardTransition:controller];
}

@end
