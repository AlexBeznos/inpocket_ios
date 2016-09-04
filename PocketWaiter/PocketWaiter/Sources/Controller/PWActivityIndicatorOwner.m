//
//  PWActivityIndicatorOwner.m
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWActivityIndicatorOwner.h"
#import "PWActivityIndicator.h"
#import "PWNoConnectionAlertController.h"

@interface PWActivityIndicatorOwner ()

@property (nonatomic, strong) PWActivityIndicator *activity;
@property (nonatomic, strong) PWModalController *internetDialog;

@end

@implementation PWActivityIndicatorOwner

- (void)startActivity
{
	if (!self.activity.animating)
	{
		[self.view addSubview:self.activity];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
					attribute:NSLayoutAttributeCenterX
					relatedBy:NSLayoutRelationEqual toItem:self.activity
					attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
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

- (void)startAsyncActivity
{

}

- (void)stopAsyncActivity
{

}

- (void)restartAsyncActivity
{

}

- (void)showNoInternetDialog
{
	__weak __typeof(self) weakSelf = self;
	PWNoConnectionAlertController *alert = [[PWNoConnectionAlertController alloc]
				initWithType:kPWConnectionTypeInternet retryAction:
	^{
		[weakSelf startAsyncActivity];
	}];
	self.internetDialog = [[PWModalController alloc]
				initWithContentController:alert autoDismiss:NO];
	[self.internetDialog showWithCompletion:nil];
}

@end
