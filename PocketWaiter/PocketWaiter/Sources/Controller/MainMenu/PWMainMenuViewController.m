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
#import "PWNearSharesViewController.h"
#import "PWNearRestaurantsViewController.h"
#import "PWPurchasesViewController.h"
#import "PWModelManager.h"

@interface PWMainMenuViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PWMainMenuViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	__weak __typeof(self) weakSelf = self;
	
	[self startActivity];
	
	[[PWModelManager sharedManager] getNearItemsWithCount:5 completion:
	^(NSArray<PWRestaurant *> *nearRestaurant,
				NSArray<PWRestaurantShare *> *nearShares,
				NSArray<PWPresentProduct *> *nearPresents, NSError *error)
	{
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

- (void)showNearRestaurants:(NSArray<PWRestaurant *> *)restaurants
			shares:(NSArray<PWRestaurantShare *> *)shares
			presents:(NSArray<PWPresentProduct *> *)presents
{
	CGFloat aspectRatio = CGRectGetWidth(self.parentViewController.view.frame) / 320.;
	__weak __typeof(self) weakSelf = self;
	
	CGFloat estimatedHeight = 0;
	
	UIView *previousView = nil;
	
	if (nil != presents)
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
					CGSizeMake(320 * aspectRatio, 375 * aspectRatio);
		estimatedHeight +=  375 * aspectRatio;
		previousView = nearPresentsController.view;
	}
	
	if (nil != shares)
	{
		PWNearSharesViewController *nearSharesController =
					[[PWNearSharesViewController alloc] initWithShares:shares
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
					CGSizeMake(320 * aspectRatio, 375 * aspectRatio);
		estimatedHeight += 375 * aspectRatio;
		previousView = nearSharesController.view;
	}
	
	if (nil != restaurants)
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
					aspectRatio * nearRestaurantsController.resizableContentSpace;
		nearRestaurantsController.contentSize =
					CGSizeMake(320 * aspectRatio, estimatedRestaurantsHeight);
		estimatedHeight += estimatedRestaurantsHeight;
	}
	
	self.scrollView.contentSize = CGSizeMake(320 * aspectRatio, estimatedHeight);
	[self stopActivity];
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

- (void)handleVelocity:(CGPoint)velocity
{
	CGFloat slideFactor = 0.2 * sqrt(velocity.x * velocity.x + velocity.y * velocity.y) / 5000;
	
	CGFloat yOffset = 0;
	
	if (velocity.y > 0)
	{
		CGFloat proposedOffset = self.scrollView.contentOffset.y -
					velocity.y * slideFactor;
		yOffset = proposedOffset > 0 ? proposedOffset : 0;
	}
	else
	{
		CGFloat proposedOffset = self.scrollView.contentOffset.y -
					velocity.y * slideFactor;
		CGFloat maxOffset = self.scrollView.contentSize.height -
					CGRectGetHeight(self.scrollView.frame);
		yOffset = proposedOffset < maxOffset ? proposedOffset : maxOffset;
	}
	NSLog(@"velocity %@ offset %f", NSStringFromCGPoint(velocity), yOffset);
	[self.scrollView setContentOffset:CGPointMake(0, yOffset) animated:YES];
}

- (void)showBonuses
{
	PWPurchasesViewController *controller = [[PWPurchasesViewController alloc]
				initWithUser:[[PWModelManager sharedManager] registeredUser]
				restaurants:nil];
	[self performForwardTransition:controller];
}

@end
