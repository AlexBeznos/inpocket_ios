//
//  PWPresentsTabController.m
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWPresentsTabController.h"
#import "PWFirstPresentController.h"
#import "PWRestaurant.h"
#import "PWModelManager.h"
#import "PWFirstPresentDetailsController.h"
#import "PWSharesViewController.h"
#import "PWPresentByBonusesViewController.h"

@interface PWScrollableViewController ()

- (void)handleVelocity:(CGPoint)velocity;

@end

@interface PWPresentsTabController ()

@property (nonatomic, strong) PWRestaurant *restaurant;
@property (nonatomic, weak) id<IPWTransiter> transiter;

@end

@implementation PWPresentsTabController

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant
			transiter:(id<IPWTransiter>)transiter
{
	self = [super init];
	if (nil != self)
	{
		self.restaurant = restaurant;
		self.transiter = transiter;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self startActivity];
	
	__weak __typeof(self) weakSelf = self;
	
	[[PWModelManager sharedManager] getFirstPresentsInfoForUser:
				[[PWModelManager sharedManager] registeredUser] restaurant:self.restaurant
				completion:
	^(PWPresentProduct *firstPresent, NSArray<PWRestaurantShare *> *shares,
				NSArray *presentsByBonuses, NSError *error)
	{
		NSInteger estimatedHeight = 0;
		UIView *previousView = nil;
		if (nil != firstPresent)
		{
			[weakSelf stopActivity];
			PWFirstPresentController *firstPresentController =
						[[PWFirstPresentController alloc] initWithPresent:firstPresent
						restaurant:weakSelf.restaurant getPresentHandler:
			^{
				PWFirstPresentDetailsController *controller =
							[[PWFirstPresentDetailsController alloc]
							initWithPresent:firstPresent
							restaurant:weakSelf.restaurant];
				[weakSelf.transiter performForwardTransition:controller];
			}];
			[weakSelf addChildViewController:firstPresentController];
			[weakSelf.scrollView addSubview:firstPresentController.view];
			
			[firstPresentController didMoveToParentViewController:weakSelf];
			firstPresentController.view.translatesAutoresizingMaskIntoConstraints = NO;
			
			[weakSelf.scrollView addConstraints:[NSLayoutConstraint
						constraintsWithVisualFormat:@"V:|[view]"
						options:0 metrics:nil
						views:@{@"view" : firstPresentController.view}]];
			[weakSelf.scrollView addConstraints:[NSLayoutConstraint
						constraintsWithVisualFormat:@"H:|[view]"
						options:0 metrics:nil
						views:@{@"view" : firstPresentController.view}]];
			
			firstPresentController.contentSize = CGSizeMake(weakSelf.contentWidth, weakSelf.contentWidth);
			previousView = firstPresentController.view;
			estimatedHeight += weakSelf.contentWidth;
		}
		
		if (nil != shares)
		{
			PWSharesViewController *sharesController =
						[[PWSharesViewController alloc] initWithShares:shares title:@"Акции"
						scrollHandler:^(CGPoint velocity)
			{
				[weakSelf handleVelocity:velocity];
			}
						transiter:weakSelf.transiter];
			sharesController.colorScheme = weakSelf.restaurant.color;
			[weakSelf addChildViewController:sharesController];
			[weakSelf.scrollView addSubview:sharesController.view];
			
			[sharesController didMoveToParentViewController:self];
			sharesController.view.translatesAutoresizingMaskIntoConstraints = NO;
			
			if (nil != previousView)
			{
				[weakSelf.scrollView addConstraint:[NSLayoutConstraint
							constraintWithItem:sharesController.view
							attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
							toItem:previousView
							attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
			}
			else
			{
				[weakSelf.scrollView addConstraints:[NSLayoutConstraint
							constraintsWithVisualFormat:@"V:|[view]"
							options:0 metrics:nil
							views:@{@"view" : sharesController.view}]];
			}
			
			[weakSelf.scrollView addConstraints:[NSLayoutConstraint
						constraintsWithVisualFormat:@"H:|[view]"
						options:0 metrics:nil
						views:@{@"view" : sharesController.view}]];
			sharesController.contentSize = CGSizeMake(weakSelf.contentWidth,
						375 *weakSelf.contentWidth / 320.);
			estimatedHeight += sharesController.contentSize.height;
			previousView = sharesController.view;
		}
		if (nil != presentsByBonuses)
		{
			PWPresentByBonusesViewController *presentsController =
						[[PWPresentByBonusesViewController alloc]
						initWithPresents:presentsByBonuses
						restaurant:weakSelf.restaurant scrollHandler:^(CGPoint velocity)
			{
				[weakSelf handleVelocity:velocity];
			}
						transiter:weakSelf.transiter];

			[weakSelf addChildViewController:presentsController];
			[weakSelf.scrollView addSubview:presentsController.view];
			
			[presentsController didMoveToParentViewController:self];
			presentsController.view.translatesAutoresizingMaskIntoConstraints = NO;
			
			if (nil != previousView)
			{
				[weakSelf.scrollView addConstraint:[NSLayoutConstraint
							constraintWithItem:presentsController.view
							attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
							toItem:previousView
							attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
			}
			else
			{
				[weakSelf.scrollView addConstraints:[NSLayoutConstraint
							constraintsWithVisualFormat:@"V:|[view]"
							options:0 metrics:nil
							views:@{@"view" : presentsController.view}]];
			}
			
			[weakSelf.scrollView addConstraints:[NSLayoutConstraint
						constraintsWithVisualFormat:@"H:|[view]"
						options:0 metrics:nil
						views:@{@"view" : presentsController.view}]];
			
			presentsController.contentSize = CGSizeMake(weakSelf.contentWidth,
						320 * weakSelf.contentWidth / 320.);
			estimatedHeight += presentsController.contentSize.height;
		}
		
		weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.contentWidth, estimatedHeight);
	}];
	
	self.scrollView.contentSize = CGSizeMake(weakSelf.contentWidth, weakSelf.contentWidth);
}

@end
