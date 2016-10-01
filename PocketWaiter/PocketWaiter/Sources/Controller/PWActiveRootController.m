//
//  PWActiveRootController.m
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWActiveRootController.h"
#import "PWTabBar.h"
#import "PWRestaurant.h"
#import "PWPurchasesViewController.h"
#import "PWModelManager.h"
#import "PWPresentsTabController.h"

@interface PWMainMenuItemViewController (Protected)

- (void)performForwardTransition:
			(UIViewController<IPWTransitableController> *)controller
			inView:(UIView *)view insets:(UIEdgeInsets)insets;

@end

@interface PWActiveRootController ()

@property (strong, nonatomic) IBOutlet PWTabBar *tabbar;
@property (nonatomic, strong) PWRestaurant *restaurant;
@property (strong, nonatomic) IBOutlet UIView *bottomBar;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomBarConstraint;
@property (strong, nonatomic) PWPresentsTabController *presentController;

@end

@implementation PWActiveRootController

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant
			transitionHandler:(PWContentTransitionHandler)aHandler
			forwardTransitionHandler:(PWContentTransitionHandler)aFwdHandler
{
	self = [super initWithTransitionHandler:aHandler forwardTransitionHandler:aFwdHandler];
	
	if (nil != self)
	{
		self.restaurant = restaurant;
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
	self.tabbar.colorSchema = self.restaurant.color;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self showPresents];
}

- (void)setupNavigation
{
	[super setupNavigation];
	
	PWUser *currentUser = [[PWModelManager sharedManager] registeredUser];
	PWUsersRestaurantInfo *info = [currentUser infoForRestaurant:self.restaurant];
	if (info.collectedBonuses > 0)
	{
		UIButton *theBonusesButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[theBonusesButton setImage:[[UIImage imageNamed:@"collectedBonus"]
					imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
					forState:UIControlStateNormal];
		[theBonusesButton setTintColor:self.restaurant.color];
		[theBonusesButton addTarget:self action:@selector(showBonuses)
					forControlEvents:UIControlEventTouchUpInside];
		[theBonusesButton sizeToFit];
		UILabel *bonussesLabel = [UILabel new];
		bonussesLabel.font = [UIFont systemFontOfSize:15.];
		bonussesLabel.text = [NSString stringWithFormat:@"%li", (unsigned long)info.collectedBonuses];
		bonussesLabel.textColor = self.restaurant.color;
		[bonussesLabel sizeToFit];
		self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]
					initWithCustomView:theBonusesButton], [[UIBarButtonItem alloc]
					initWithCustomView:bonussesLabel]];
	}
}

- (UIColor *)titleColor
{
	return self.restaurant.color;
}

- (NSString *)name
{
	return self.restaurant.name;
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
}

- (void)showPresents
{
	[self clearViews];
	PWPresentsTabController *presentsController = [[PWPresentsTabController
				alloc] initWithRestaurant:self.restaurant transiter:self];
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

}

- (void)showReviews
{

}

- (void)showAbout
{

}

- (void)showBonuses
{
	PWPurchasesViewController *controller = [[PWPurchasesViewController alloc]
				initWithUser:[[PWModelManager sharedManager] registeredUser]
				restaurants:@[self.restaurant]];
	[self performForwardTransition:controller];
}

@end
