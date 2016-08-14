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
	[theTitleLabel sizeToFit];
	
	self.navigationItem.leftBarButtonItems =
				@[self.navigationItem.leftBarButtonItem,
				[[UIBarButtonItem alloc] initWithCustomView:theTitleLabel]];
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


@end
