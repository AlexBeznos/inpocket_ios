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

@interface PWMainMenuViewController ()

@property (nonatomic, copy) PWContentTransitionHandler transitionHandler;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PWMainMenuViewController

- (instancetype)initWithTransitionHandler:(PWContentTransitionHandler)aHandler
{
	self = [super init];
	
	if (nil != self)
	{
		self.transitionHandler = aHandler;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	[self setupNavigationBar];
	
	[self setupMenuItemWithTarget:self action:@selector(transitionBack)];
	
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
	CGFloat aspectRatio = CGRectGetWidth(self.parentViewController.view.frame) / 320.;
	
	__weak __typeof(self) theWeakSelf = self;
	
	PWNearPresentsViewController *nearPresentsController =
				[[PWNearPresentsViewController alloc] initWithScrollHandler:
	^(CGPoint velocity)
	{
		[theWeakSelf handleVelocity:velocity];
	}];
	
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
	}];
	
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
	}];
	
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
	
	self.scrollView.contentSize = CGSizeMake(320 * aspectRatio,  2 * 375 * aspectRatio + estimatedHeight);
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

- (void)transitionBack
{
	if (nil != self.transitionHandler)
	{
		self.transitionHandler();
	}
}

- (void)showBonuses
{

}

@end
