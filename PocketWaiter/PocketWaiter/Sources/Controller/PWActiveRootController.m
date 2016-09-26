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
	self.tabbar.colorSchema = [UIColor blackColor];
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

@end
