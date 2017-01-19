//
//  PWMenuTabController.m
//  PocketWaiter
//
//  Created by Www Www on 10/3/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWMenuTabController.h"
#import "PWRestaurant.h"
#import "PWModelManager.h"
#import "PWFirstPresentDetailsController.h"
#import "PWSharesViewController.h"
#import "PWProductViewController.h"
#import "PWBestOfDayViewController.h"

@interface PWScrollableViewController ()

- (void)handleVelocity:(CGPoint)velocity;

@end

@interface PWMenuTabController ()

@property (nonatomic, strong) PWRestaurant *restaurant;
@property (nonatomic, weak) id<IPWTransiter> transiter;
@property (nonatomic) BOOL defaultMode;

@end

@implementation PWMenuTabController

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
	
	[[PWModelManager sharedManager] getRootMenuInfoForUser:[[PWModelManager sharedManager] registeredUser] restaurant:self.restaurant completion:
	^(NSArray<PWProduct *> *bestOfDay, NSDictionary<NSString *, NSArray<PWProduct *> *> *categories, NSError *error)
	{
		[weakSelf stopActivity];
		NSInteger estimatedHeight = 0;
		UIView *previousView = nil;
		if (0 != bestOfDay.count)
		{
			PWBestOfDayViewController *productOfDay =
						[[PWBestOfDayViewController alloc] initWithProducts:bestOfDay restaurant:weakSelf.restaurant
						scrollHandler:^(CGPoint velocity)
			{
				[weakSelf handleVelocity:velocity];
			}
						transiter:weakSelf.transiter];
			[weakSelf addChildViewController:productOfDay];
			[weakSelf.scrollView addSubview:productOfDay.view];
			
			[productOfDay didMoveToParentViewController:self];
			productOfDay.view.translatesAutoresizingMaskIntoConstraints = NO;
			
			if (nil != previousView)
			{
				[weakSelf.scrollView addConstraint:[NSLayoutConstraint
							constraintWithItem:productOfDay.view
							attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
							toItem:previousView
							attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
			}
			else
			{
				[weakSelf.scrollView addConstraints:[NSLayoutConstraint
							constraintsWithVisualFormat:@"V:|[view]"
							options:0 metrics:nil
							views:@{@"view" : productOfDay.view}]];
			}
			
			[weakSelf.scrollView addConstraints:[NSLayoutConstraint
						constraintsWithVisualFormat:@"H:|[view]"
						options:0 metrics:nil
						views:@{@"view" : productOfDay.view}]];
			productOfDay.contentSize = CGSizeMake(weakSelf.contentWidth,
						375 * weakSelf.contentWidth / 290.);
			estimatedHeight += productOfDay.contentSize.height;
			previousView = productOfDay.view;
		}
		
		for (NSString *categoryName in categories.allKeys)
		{
			 NSArray<PWProduct *> *products = categories[categoryName];
			 PWProductViewController *presentsController =
						[[PWProductViewController alloc]
						initWithProducts:products
						restaurant:weakSelf.restaurant scrollHandler:^(CGPoint velocity)
			{
				[weakSelf handleVelocity:velocity];
			}
						transiter:weakSelf.transiter title:categoryName isPresents:NO];

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
			previousView = presentsController.view;
		}
		
		weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.contentWidth, estimatedHeight);
	}];
	
	self.scrollView.contentSize = CGSizeMake(weakSelf.contentWidth, weakSelf.contentWidth);
}

@end

