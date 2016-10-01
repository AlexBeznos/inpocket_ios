//
//  PWScrollableViewController.m
//  PocketWaiter
//
//  Created by Www Www on 10/1/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWScrollableViewController.h"
#import "PWActivityIndicator.h"
#import "PWNoConnectionAlertController.h"

@interface PWScrollableViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) PWActivityIndicator *activity;
@property (nonatomic, strong) PWModalController *internetDialog;

@end

@implementation PWScrollableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.scrollView = [UIScrollView new];
	self.scrollView.backgroundColor = [UIColor clearColor];
	self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view insertSubview:self.scrollView atIndex:0];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
				options:0 metrics:nil views:@{@"view" : self.scrollView}]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
				options:0 metrics:nil views:@{@"view" : self.scrollView}]];
}

- (void)startActivity
{
	[self startActivityInView:self.view];
}

- (void)startActivityInView:(UIView *)view
{
	if (!self.activity.animating)
	{
		[view addSubview:self.activity];
		[view addConstraint:[NSLayoutConstraint constraintWithItem:view
					attribute:NSLayoutAttributeCenterX
					relatedBy:NSLayoutRelationEqual toItem:self.activity
					attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
		[view addConstraint:[NSLayoutConstraint constraintWithItem:view
					attribute:NSLayoutAttributeCenterY
					relatedBy:NSLayoutRelationEqual toItem:self.activity
					attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
		[self.activity startAnimating];
	}
}

- (void)startActivityWithTopOffset:(CGFloat)offset
{
	if (!self.activity.animating)
	{
		[self.view addSubview:self.activity];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
					attribute:NSLayoutAttributeCenterX
					relatedBy:NSLayoutRelationEqual toItem:self.activity
					attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
					attribute:NSLayoutAttributeTop
					relatedBy:NSLayoutRelationEqual toItem:self.activity
					attribute:NSLayoutAttributeTop multiplier:1.0 constant:offset]];
		[self.activity startAnimating];
	}
}

- (void)stopActivity
{
	if (self.activity.animating)
	{
		[self.activity stopAnimating];
		[self.activity removeFromSuperview];
	}
}

- (PWActivityIndicator *)activity
{
	if (nil == _activity)
	{
		_activity = [PWActivityIndicator new];
		_activity.translatesAutoresizingMaskIntoConstraints = NO;
		[_activity addConstraint:[NSLayoutConstraint constraintWithItem:_activity
					attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
					toItem:nil attribute:NSLayoutAttributeNotAnAttribute
					multiplier:1.0 constant:40]];
		[_activity addConstraint:[NSLayoutConstraint constraintWithItem:_activity
					attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
					toItem:nil attribute:NSLayoutAttributeNotAnAttribute
					multiplier:1.0 constant:40]];
	}
	
	return _activity;
}

- (void)resumeActivity
{

}

- (void)suspendActivity
{

}

- (void)showNoInternetDialog
{
	__weak __typeof(self) weakSelf = self;
	PWNoConnectionAlertController *alert = [[PWNoConnectionAlertController alloc]
				initWithType:kPWConnectionTypeInternet retryAction:
	^{
		[weakSelf resumeActivity];
	}];
	self.internetDialog = [[PWModalController alloc]
				initWithContentController:alert autoDismiss:NO];
	[self.internetDialog showWithCompletion:nil];
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

@end
