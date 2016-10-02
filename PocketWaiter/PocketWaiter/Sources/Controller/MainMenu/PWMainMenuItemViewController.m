//
//  PWMainMenuItemViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/14/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWMainMenuItemViewController.h"
#import "PWTouchView.h"
#import "UIViewControllerAdditions.h"
#import "UIColorAdditions.h"

@interface PWMainMenuItemViewController ()

@property (nonatomic, copy) PWContentTransitionHandler transitionHandler;
@property (nonatomic, copy) PWContentTransitionHandler forwardTransitionHandler;
@property (nonatomic) BOOL isTransited;
@property (nonatomic, strong) PWTouchView *touchView;
@property (nonatomic, strong) NSLayoutConstraint *trasitedConstraint;
@property (nonatomic, strong) NSMutableArray *transitedControllers;

@end

@implementation PWMainMenuItemViewController

@synthesize transitedController;

- (instancetype)initWithTransitionHandler:(PWContentTransitionHandler)aHandler
			forwardTransitionHandler:(PWContentTransitionHandler)aForwardHandler
{
	self = [super init];
	
	if (nil != self)
	{
		self.transitionHandler = aHandler;
		self.forwardTransitionHandler = aForwardHandler;
		self.transitedControllers = [NSMutableArray array];
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self setupNavigation];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	
	self.isTransited = NO;
}

- (void)setupNavigation
{
	[self setupMenuItemWithTarget:self action:@selector(transitionBack)
				navigationItem:self.navigationItem];
				
	UILabel *theTitleLabel = [UILabel new];
	theTitleLabel.text = self.name;
	theTitleLabel.font = [UIFont systemFontOfSize:20];
	theTitleLabel.textColor = [self titleColor];
	[theTitleLabel sizeToFit];
	
	self.navigationItem.leftBarButtonItems =
				@[self.navigationItem.leftBarButtonItem,
				[[UIBarButtonItem alloc] initWithCustomView:theTitleLabel]];
}

- (UIColor *)titleColor
{
	return [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self setupNavigationBar];
}

- (void)resetTransition
{
	[self.touchView removeFromSuperview];
	self.isTransited = NO;
}

- (void)transitionBack
{
	if (self.isTransited)
	{
		if (nil != self.forwardTransitionHandler)
		{
			[self.touchView removeFromSuperview];
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
		
		self.touchView = touchView;
		if (nil != self.transitionHandler)
		{
			self.transitionHandler();
			self.isTransited = YES;
		}
	}
}

- (void)performBackTransitionToRoot
{
	for (NSInteger i = 0; i < (NSInteger)self.transitedControllers.count - 1; i++)
	{
		[[self.transitedControllers[i] view] removeFromSuperview];
	}
	
	[self.transitedControllers removeAllObjects];
	[self performBackTransition];
}

- (void)performBackTransition
{
	[self.transitedControllers removeObject:self.transitedController];
	
	if (nil == [self.transitedControllers lastObject])
	{
		[self setupNavigation];
	}
	else
	{
		[[self.transitedControllers lastObject] setupWithNavigationItem:self.navigationItem];
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
		self.transitedController = [self.transitedControllers lastObject];
	}];
}

- (void)performForwardTransition:
			(UIViewController<IPWTransitableController> *)controller
			inView:(UIView *)view insets:(UIEdgeInsets)insets
{
	[self.transitedControllers addObject:controller];
	controller.transiter = self;
	[controller setupWithNavigationItem:self.navigationItem];
	self.transitedController = controller;
	self.trasitedConstraint = [self navigateViewController:controller inView:view withOffsets:insets];
}

- (void)performForwardTransition:
			(UIViewController<IPWTransitableController> *)controller
{
	[self performForwardTransition:controller inView:self.view insets:UIEdgeInsetsMake(0, 0, 0, 0)];
}


@end
