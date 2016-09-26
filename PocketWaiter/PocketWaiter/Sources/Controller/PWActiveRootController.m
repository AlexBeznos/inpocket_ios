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

@interface PWActiveRootController ()

@property (strong, nonatomic) IBOutlet PWTabBar *tabbar;
@property (nonatomic, strong) PWRestaurant *restaurant;

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
		bonussesLabel.text = [NSString stringWithFormat:@"%li", info.collectedBonuses];
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

- (void)showPresents
{

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
