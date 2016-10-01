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
				NSArray *presentByBonuses, NSError *error)
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
			
			firstPresentController.contentSize = weakSelf.contentSize;
			previousView = firstPresentController.view;
			estimatedHeight += weakSelf.contentSize.height;
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
			
			sharesController.contentSize = CGSizeMake(weakSelf.contentSize.width,
						375 * weakSelf.contentSize.height / 320.);
			estimatedHeight += sharesController.contentSize.height;
			previousView = sharesController.view;
		}
		
		weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.contentSize.width, estimatedHeight);
	}];
	
	self.scrollView.contentSize = weakSelf.contentSize;
}

@end
