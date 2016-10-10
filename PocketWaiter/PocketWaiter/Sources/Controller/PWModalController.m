//
//  PWModalController.m
//  PocketWaiter
//
//  Created by Www Www on 8/20/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWModalController.h"
#import "UIColorAdditions.h"
#import "PWTouchView.h"

@interface PWModalController ()

@property (nonatomic, strong) UIViewController<IPWModalContentController> *contentController;
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@property (nonatomic) BOOL autoDismiss;

@end

@implementation PWModalController

- (instancetype)initWithContentController:
			(UIViewController<IPWModalContentController> *)controller autoDismiss:(BOOL)autodismiss
{
	self = [super init];
	
	if (nil != self)
	{
		self.contentController = controller;
		self.autoDismiss = autodismiss;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UIView *backgroundView = [UIView new];
	backgroundView.backgroundColor = [UIColor pwColorWithAlpha:0.5];
	
	[self addView:backgroundView];
	
	if (self.autoDismiss)
	{
		__weak __typeof(self) weakSelf = self;
		PWTouchView *touchView = [[PWTouchView alloc] initWithTouchHandler:
		^{
			weakSelf.view.userInteractionEnabled = NO;
			[weakSelf hideWithCompletion:
			^{
				weakSelf.view.userInteractionEnabled = YES;
			}];
		}];
		
		[self addView:touchView];
	}
	
	[self addChildViewController:self.contentController];
	self.contentController.view.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.contentController.view];
	
	[self.contentController.view addConstraint:[NSLayoutConstraint
				constraintWithItem:self.contentController.view attribute:NSLayoutAttributeHeight
				relatedBy:NSLayoutRelationEqual toItem:nil
				attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:self.contentController.contentSize.height]];
	
	[self.view addConstraint:[NSLayoutConstraint
				constraintWithItem:self.contentController.view attribute:NSLayoutAttributeWidth
				relatedBy:NSLayoutRelationEqual toItem:nil
				attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:self.contentController.contentSize.width]];
	
	[self.view addConstraint:[NSLayoutConstraint
				constraintWithItem:self.view attribute:NSLayoutAttributeCenterX
				relatedBy:NSLayoutRelationEqual toItem:self.contentController.view
				attribute:NSLayoutAttributeCenterX multiplier:1
				constant:0]];
	self.topConstraint = [NSLayoutConstraint
				constraintWithItem:self.view attribute:NSLayoutAttributeTop
				relatedBy:NSLayoutRelationEqual toItem:self.contentController.view
				attribute:NSLayoutAttributeTop multiplier:1
				constant:0];
	[self.view addConstraint:self.topConstraint];
}

- (void)addView:(UIView *)view
{
	view.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:view];
	[self.view addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : view}]];
	[self.view addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : view}]];
}

- (void)showWithCompletion:(void (^)())aCompletion
{
	UIWindow *window = [UIApplication sharedApplication].delegate.window;
	self.view.translatesAutoresizingMaskIntoConstraints = NO;
	[window addSubview:self.view];
	
	[window addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]|" options:0
				metrics:nil views:@{@"view" : self.view}]];
	
	[window addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]|" options:0
				metrics:nil views:@{@"view" : self.view}]];
	
	self.topConstraint.constant = -self.contentController.contentSize.height;
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
	
	[UIView animateWithDuration:0.25 animations:
	^{
		self.topConstraint.constant = -134;
		[self.view setNeedsLayout];
		[self.view layoutIfNeeded];
	}
				completion:^(BOOL finished)
	{
		if (nil != aCompletion)
		{
			aCompletion();
		}
	}];
}

- (void)hideWithCompletion:(void (^)())aCompletion
{
	[UIView animateWithDuration:0.25 animations:
	^{
		self.topConstraint.constant = self.contentController.contentSize.height;
		[self.view setNeedsLayout];
		[self.view layoutIfNeeded];
	}
				completion:^(BOOL finished)
	{
		[self.view removeFromSuperview];
		if (nil != aCompletion)
		{
			aCompletion();
		}
	}];
}

@end
