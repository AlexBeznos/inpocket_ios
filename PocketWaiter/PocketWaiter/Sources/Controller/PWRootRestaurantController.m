//
//  PWActiveRootController.m
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRootRestaurantController.h"
#import "PWTabBar.h"
#import "PWRestaurant.h"
#import "PWPurchasesViewController.h"
#import "PWModelManager.h"
#import "PWPresentsTabController.h"
#import "PWMenuTabController.h"
#import "PWReviewsTabController.h"
#import "PWAboutUsTabController.h"
#import "UIColorAdditions.h"

@interface PWMainMenuItemViewController (Protected)

- (void)performForwardTransition:
			(UIViewController<IPWTransitableController> *)controller
			inView:(UIView *)view insets:(UIEdgeInsets)insets;

@end

@interface PWRootRestaurantController ()

@property (strong, nonatomic) IBOutlet PWTabBar *tabbar;
@property (strong, nonatomic) PWRestaurant *restaurant;
@property (strong, nonatomic) IBOutlet UIView *bottomBar;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomBarConstraint;
@property (strong, nonatomic) PWPresentsTabController *presentController;
@property (strong, nonatomic) PWMenuTabController *menuController;
@property (strong, nonatomic) PWReviewsTabController *reviewsController;
@property (strong, nonatomic) PWAboutUsTabController *aboutController;

@property (nonatomic, strong) UIButton *callWaiterButton;
@property (nonatomic, strong) UIButton *orderButton;

@property (nonatomic) BOOL defaultMode;

@end

@implementation PWRootRestaurantController

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant
			defaultMode:(BOOL)defaultMode
			transitionHandler:(PWContentTransitionHandler)aHandler
			forwardTransitionHandler:(PWContentTransitionHandler)aFwdHandler
{
	self = [super initWithTransitionHandler:aHandler forwardTransitionHandler:aFwdHandler];
	
	if (nil != self)
	{
		self.restaurant = restaurant;
		self.defaultMode = defaultMode;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.scrollView.scrollEnabled = NO;
	
	__weak __typeof(self) weakSelf = self;
	PWTabBarItem *presents = [[PWTabBarItem alloc] initWithTitle:@"ПОДАРКИ" handler:
	^{
		[weakSelf showPresents];
	}];
	PWTabBarItem *menu = [[PWTabBarItem alloc] initWithTitle:@"МЕНЮ" handler:
	^{
		[weakSelf showMenu];
	}];
	
	PWTabBarItem *reviews = [[PWTabBarItem alloc] initWithTitle:@"ОТЗЫВЫ" handler:
	^{
		[weakSelf showReviews];
	}];
	PWTabBarItem *about = [[PWTabBarItem alloc] initWithTitle:@"О НАС" handler:
	^{
		[weakSelf showAbout];
	}];
	
	[self.tabbar addItem:presents];
	[self.tabbar addItem:menu];
	[self.tabbar addItem:reviews];
	[self.tabbar addItem:about];
	self.tabbar.colorSchema = self.defaultMode ?
				[UIColor pwColorWithAlpha:1] : self.restaurant.color;
	
	[self.bottomBar addSubview:self.orderButton];
	[self.bottomBar addConstraint:[NSLayoutConstraint
				constraintWithItem:self.orderButton attribute:NSLayoutAttributeLeft
				relatedBy:NSLayoutRelationEqual toItem:self.bottomBar
				attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
	[self.bottomBar addConstraint:[NSLayoutConstraint
				constraintWithItem:self.orderButton attribute:NSLayoutAttributeCenterY
				relatedBy:NSLayoutRelationEqual toItem:self.bottomBar
				attribute:NSLayoutAttributeCenterY multiplier:1 constant:10]];
	
	[self.bottomBar addSubview:self.callWaiterButton];
	[self.bottomBar addConstraint:[NSLayoutConstraint
				constraintWithItem:self.callWaiterButton attribute:NSLayoutAttributeRight
				relatedBy:NSLayoutRelationEqual toItem:self.bottomBar
				attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
	[self.bottomBar addConstraint:[NSLayoutConstraint
				constraintWithItem:self.callWaiterButton attribute:NSLayoutAttributeCenterY
				relatedBy:NSLayoutRelationEqual toItem:self.bottomBar
				attribute:NSLayoutAttributeCenterY multiplier:1 constant:10]];
	self.bottomBar.backgroundColor = self.defaultMode ?
				[UIColor pwColorWithAlpha:1] : self.restaurant.color;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self showPresents];
}

- (void)setupNavigation
{
	[super setupNavigation];
	
	if (self.restaurant.collectedBonuses > 0)
	{
		UIButton *theBonusesButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[theBonusesButton setImage:[[UIImage imageNamed:@"collectedBonus"]
					imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
					forState:UIControlStateNormal];
		[theBonusesButton setTintColor:self.defaultMode ?
				[UIColor pwColorWithAlpha:1] : self.restaurant.color];
		[theBonusesButton addTarget:self action:@selector(showBonuses)
					forControlEvents:UIControlEventTouchUpInside];
		[theBonusesButton sizeToFit];
		UILabel *bonussesLabel = [UILabel new];
		bonussesLabel.font = [UIFont systemFontOfSize:15.];
		bonussesLabel.text = [NSString stringWithFormat:@"%li", (unsigned long)self.restaurant.collectedBonuses];
		bonussesLabel.textColor = self.defaultMode ?
				[UIColor pwColorWithAlpha:1] : self.restaurant.color;;
		[bonussesLabel sizeToFit];
		self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]
					initWithCustomView:theBonusesButton], [[UIBarButtonItem alloc]
					initWithCustomView:bonussesLabel]];
	}
}

- (UIColor *)titleColor
{
	return self.defaultMode ?
				[UIColor pwColorWithAlpha:1] : self.restaurant.color;;
}

- (NSString *)name
{
	return self.restaurant.restaurantName;
}

- (void)performForwardTransition:
			(UIViewController<IPWTransitableController> *)controller
{
	[self performForwardTransition:controller
				inView:self.view insets:[controller isKindOfClass:[PWPurchasesViewController class]] ?
				UIEdgeInsetsMake(0, 0, 0, 0) :
				UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.bottomBar.frame), 0)];
}

- (void)clearViews
{
	[self.presentController.view removeFromSuperview];
	[self.presentController removeFromParentViewController];
	
	[self.menuController.view removeFromSuperview];
	[self.menuController removeFromParentViewController];
	
	[self.reviewsController.view removeFromSuperview];
	[self.reviewsController removeFromParentViewController];
	
	[self.aboutController.view removeFromSuperview];
	[self.aboutController removeFromParentViewController];
}

- (void)showPresents
{
	[self clearViews];
	PWPresentsTabController *presentsController = [[PWPresentsTabController
				alloc] initWithRestaurant:self.restaurant transiter:self
				defaultMode:self.defaultMode];
	CGFloat aspectRatio = CGRectGetWidth(self.parentViewController.view.frame) / 320.;
	presentsController.contentWidth = 320 * aspectRatio;
	[self addChildViewController:presentsController];
	[self.contentView addSubview:presentsController.view];
			
	[presentsController didMoveToParentViewController:self];
	presentsController.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.contentView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : presentsController.view}]];
	[self.contentView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : presentsController.view}]];
	self.presentController = presentsController;
}

- (void)showMenu
{
	[self clearViews];
	PWMenuTabController *menuController = [[PWMenuTabController
				alloc] initWithRestaurant:self.restaurant transiter:self
				defaultMode:self.defaultMode];
	CGFloat aspectRatio = CGRectGetWidth(self.parentViewController.view.frame) / 320.;
	menuController.contentWidth = 320 * aspectRatio;
	[self addChildViewController:menuController];
	[self.contentView addSubview:menuController.view];
			
	[menuController didMoveToParentViewController:self];
	menuController.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.contentView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : menuController.view}]];
	[self.contentView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : menuController.view}]];
	self.menuController = menuController;
}

- (void)showReviews
{
	[self clearViews];
	PWReviewsTabController *reviewsControler = [[PWReviewsTabController
				alloc] initWithRestaurant:self.restaurant transiter:self
				defaultMode:self.defaultMode];
	CGFloat aspectRatio = CGRectGetWidth(self.parentViewController.view.frame) / 320.;
	reviewsControler.contentWidth = 320 * aspectRatio;
	[self addChildViewController:reviewsControler];
	[self.contentView addSubview:reviewsControler.view];
			
	[reviewsControler didMoveToParentViewController:self];
	reviewsControler.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.contentView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : reviewsControler.view}]];
	[self.contentView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : reviewsControler.view}]];
	self.reviewsController = reviewsControler;
}

- (void)showAbout
{
	[self clearViews];
	PWAboutUsTabController *aboutController = [[PWAboutUsTabController
				alloc] initWithRestaurant:self.restaurant transiter:self
				defaultMode:self.defaultMode];
	CGFloat aspectRatio = CGRectGetWidth(self.parentViewController.view.frame) / 320.;
	aboutController.contentWidth = 320 * aspectRatio;
	[self addChildViewController:aboutController];
	[self.contentView addSubview:aboutController.view];
			
	[aboutController didMoveToParentViewController:self];
	aboutController.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.contentView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : aboutController.view}]];
	[self.contentView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : aboutController.view}]];
	self.aboutController = aboutController;
}

- (void)showBonuses
{
	PWPurchasesViewController *controller = [[PWPurchasesViewController alloc]
				initWithUser:[[PWModelManager sharedManager] registeredUser]
				restaurants:@[self.restaurant]];
	[self performForwardTransition:controller];
}

- (UIButton *)callWaiterButton
{
	if (nil == _callWaiterButton)
	{
		_callWaiterButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_callWaiterButton.backgroundColor = [UIColor clearColor];
		_callWaiterButton.translatesAutoresizingMaskIntoConstraints = NO;
		[_callWaiterButton addConstraint:[NSLayoutConstraint
					constraintWithItem:_callWaiterButton attribute:NSLayoutAttributeWidth
					relatedBy:NSLayoutRelationEqual toItem:nil
					attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40]];
		[_callWaiterButton addConstraint:[NSLayoutConstraint
					constraintWithItem:_callWaiterButton attribute:NSLayoutAttributeHeight
					relatedBy:NSLayoutRelationEqual toItem:nil
					attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40]];
		
		[_callWaiterButton setImage:[UIImage imageNamed:@"bell"] forState:UIControlStateNormal];
		[_callWaiterButton addTarget:self action:@selector(callWaiter)
					forControlEvents:UIControlEventTouchUpInside];
	}
	
	return _callWaiterButton;
}

- (UIButton *)orderButton
{
	if (nil == _orderButton)
	{
		_orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_orderButton.backgroundColor = [UIColor clearColor];
		_orderButton.translatesAutoresizingMaskIntoConstraints = NO;
		[_orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_orderButton addTarget:self action:@selector(showOrder)
					forControlEvents:UIControlEventTouchUpInside];
		PWUser *currentUser = [[PWModelManager sharedManager] registeredUser];
		PWPurchase *currentPurchase = currentUser.currentPurchases[self.restaurant.restaurantName];
		
		[_orderButton setTitle:[NSString stringWithFormat:@"Ваш заказ %@",
					currentPurchase.totalPrice.humanReadableValue] forState:UIControlStateNormal];
	}
	
	return _orderButton;
}

- (void)callWaiter
{

}

- (void)showOrder
{

}

@end
