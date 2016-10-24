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
#import "PWProductViewController.h"
#import "UIColorAdditions.h"

@interface PWScrollableViewController ()

- (void)handleVelocity:(CGPoint)velocity;

@end

@interface PWPresentsTabController ()

@property (nonatomic, strong) PWRestaurant *restaurant;
@property (nonatomic, weak) id<IPWTransiter> transiter;
@property (nonatomic) BOOL defaultMode;

@end

@implementation PWPresentsTabController

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant
			transiter:(id<IPWTransiter>)transiter defaultMode:(BOOL)defaultMode
{
	self = [super init];
	if (nil != self)
	{
		self.restaurant = restaurant;
		self.transiter = transiter;
		self.defaultMode = defaultMode;
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
		[weakSelf stopActivity];
		NSInteger estimatedHeight = 0;
		UIView *previousView = nil;
		if (nil != firstPresent)
		{
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
		
		if (0 != shares.count)
		{
			PWSharesViewController *sharesController =
						[[PWSharesViewController alloc] initWithShares:shares title:@"Акции"
						scrollHandler:^(CGPoint velocity)
			{
				[weakSelf handleVelocity:velocity];
			}
						transiter:weakSelf.transiter];
			sharesController.colorScheme = weakSelf.defaultMode ?
						[UIColor pwColorWithAlpha:1] : weakSelf.restaurant.color;
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
		if (0 != presentsByBonuses.count)
		{
			PWProductViewController *presentsController =
						[[PWProductViewController alloc]
						initWithProducts:presentsByBonuses
						restaurant:weakSelf.restaurant scrollHandler:^(CGPoint velocity)
			{
				[weakSelf handleVelocity:velocity];
			}
						transiter:weakSelf.transiter title:@"Подарки за бонусами" isPresents:YES];

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
