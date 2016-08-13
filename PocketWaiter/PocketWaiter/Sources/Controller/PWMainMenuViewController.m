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
#import "UIColorAdditions.h"
#import "PWNearRestaurantsViewController.h"
#import "PWTouchView.h"

@interface PWMainMenuViewController () <IPWTransiter>

@property (nonatomic, copy) PWContentTransitionHandler transitionHandler;
@property (nonatomic, copy) PWContentTransitionHandler forwardTransitionHandler;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) BOOL isTransited;
@property (nonatomic, strong) NSLayoutConstraint *trasitedConstraint;

@end

@implementation PWMainMenuViewController

@synthesize transitedController;

- (instancetype)initWithTransitionHandler:(PWContentTransitionHandler)aHandler
			forwardTransitionHandler:(PWContentTransitionHandler)aForwardHandler
{
	self = [super init];
	
	if (nil != self)
	{
		self.transitionHandler = aHandler;
		self.forwardTransitionHandler = aForwardHandler;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.isTransited = NO;
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	[self setupNavigationBar];
	
	CGFloat aspectRatio = CGRectGetWidth(self.parentViewController.view.frame) / 320.;
	
	__weak __typeof(self) theWeakSelf = self;
	
	PWNearPresentsViewController *nearPresentsController =
				[[PWNearPresentsViewController alloc] initWithScrollHandler:
	^(CGPoint velocity)
	{
		[theWeakSelf handleVelocity:velocity];
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
	
	PWNearSharesViewController *nearSharesController =
				[[PWNearSharesViewController alloc] initWithScrollHandler:
	^(CGPoint velocity)
	{
		[theWeakSelf handleVelocity:velocity];
	}
				transiter:self];
	
	[self addChildViewController:nearSharesController];
	[self.scrollView addSubview:nearSharesController.view];
	
	[nearPresentsController didMoveToParentViewController:self];
	nearPresentsController.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.scrollView addConstraint:[NSLayoutConstraint
				constraintWithItem:nearSharesController.view
				attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
				toItem:nearPresentsController.view
				attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	
	[self.scrollView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]"
				options:0 metrics:nil
				views:@{@"view" : nearSharesController.view}]];
	
	nearSharesController.contentSize =
				CGSizeMake(320 * aspectRatio, 375 * aspectRatio);
	
	PWNearRestaurantsViewController *nearRestaurantsController =
				[[PWNearRestaurantsViewController alloc] initWithScrollHandler:
	^(CGPoint velocity)
	{
		[theWeakSelf handleVelocity:velocity];
	}
				transiter:self];
	
	[self addChildViewController:nearRestaurantsController];
	[self.scrollView addSubview:nearRestaurantsController.view];
	
	[nearRestaurantsController didMoveToParentViewController:self];
	nearRestaurantsController.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.scrollView addConstraint:[NSLayoutConstraint
				constraintWithItem:nearRestaurantsController.view
				attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
				toItem:nearSharesController.view
				attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	
	[self.scrollView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]"
				options:0 metrics:nil
				views:@{@"view" : nearRestaurantsController.view}]];
	
	CGFloat estimatedHeight = nearRestaurantsController.fixedContentSpace +
				aspectRatio * nearRestaurantsController.resizableContentSpace;
	nearRestaurantsController.contentSize =
				CGSizeMake(320 * aspectRatio, estimatedHeight);
	
	self.scrollView.contentSize = CGSizeMake(320 * aspectRatio,
				2 * 375 * aspectRatio + estimatedHeight);
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self setupNavigation];
}

- (void)setupNavigation
{
	[self setupMenuItemWithTarget:self action:@selector(transitionBack)
				navigationItem:self.navigationItem];
	
	UILabel *theTitleLabel = [UILabel new];
	theTitleLabel.text = @"InPocket";
	theTitleLabel.font = [UIFont systemFontOfSize:20];
	[theTitleLabel sizeToFit];
	
	self.navigationItem.leftBarButtonItems =
				@[self.navigationItem.leftBarButtonItem,
				[[UIBarButtonItem alloc] initWithCustomView:theTitleLabel]];
	
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

- (void)performBackTransitionWithSetupNaigationItem:(BOOL)setup
{
	if (setup)
	{
		[self setupNavigation];
	}
	[UIView animateWithDuration:0.25 animations:
	^{
		self.trasitedConstraint.constant = -CGRectGetWidth(self.view.frame);
		[self.view setNeedsLayout];
		[self.view layoutIfNeeded];
	}
	completion:^(BOOL finished)
	{
		[self.transitedController.view removeFromSuperview];
		[self.transitedController removeFromParentViewController];
		self.transitedController = nil;
	}];
}

- (void)performForwardTransition:
			(UIViewController<IPWTransitableController> *)controller
{
	controller.transiter = self;
	[controller setupWithNavigationItem:self.navigationItem];
	self.transitedController = controller;
	self.trasitedConstraint = [self navigateViewController:controller];
}

- (void)transitionBack
{
	if (self.isTransited)
	{
		if (nil != self.forwardTransitionHandler)
		{
			self.forwardTransitionHandler();
			self.isTransited = NO;
		}
	}
	else
	{
		__weak __typeof(self) theWeakSelf = self;
		PWTouchView *touchView = [[PWTouchView alloc] initWithTouchHandler:
		^{
			if (nil != theWeakSelf.forwardTransitionHandler)
			{
				theWeakSelf.forwardTransitionHandler();
				theWeakSelf.isTransited = NO;
			}
		}];
		
		touchView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.view addSubview:touchView];
		[self.view addConstraints:[NSLayoutConstraint
					constraintsWithVisualFormat:@"H:|[view]|" options:0
					metrics:nil views:@{@"view" : touchView}]];
		[self.view addConstraints:[NSLayoutConstraint
					constraintsWithVisualFormat:@"V:|[view]|" options:0
					metrics:nil views:@{@"view" : touchView}]];
		
		if (nil != self.transitionHandler)
		{
			self.transitionHandler();
			self.isTransited = YES;
		}
	}
}

- (void)showBonuses
{

}

@end
