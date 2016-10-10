//
//  PWNoAccesViewController.m
//  PocketWaiter
//
//  Created by Www Www on 10/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWNoAccesViewController.h"
#import "UIColorAdditions.h"

@interface PWNoAccesViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondStepLabel;
@property (strong, nonatomic) IBOutlet UILabel *thirdStepLabel;
@property (strong, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, strong) NSLayoutConstraint *constraint;

@property (nonatomic) PWUtilType type;

@end

@implementation PWNoAccesViewController

- (instancetype)initWithType:(PWUtilType)type
{
	self = [super init];
	
	if (nil != self)
	{
		self.type = type;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor pwColorWithAlpha:0.8];
	
	self.titleLabel.text = @"Для работы в приложении необходимо разрешить "
				"доступ к камере в настройках приложения";
	self.firstStepLabel.text = @"1. Зайдите в настройки";
	self.secondStepLabel.text = @"2. Найдите приложение InPocket";
	self.thirdStepLabel.text = [NSString stringWithFormat:
				@"3. Разрешите доступ к %@", self.type == kPWUtilTypeCamera ?
				@"камере" : @"фотографиям"];
	[self.button addTarget:self action:@selector(closeScreen:)
				forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeScreen:(id)sender
{
	[self hideWithCompletion:nil];
}

- (void)showWithCompletion:(void (^)())aCompletion
{
	self.view.translatesAutoresizingMaskIntoConstraints = NO;
	UIViewController *rootController = [UIApplication sharedApplication].delegate.window.rootViewController;
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.view
				attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
				toItem:NSLayoutRelationEqual
				attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:CGRectGetHeight(rootController.view.frame)];
	
	[self.view addConstraint:constraint];
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
				attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
				toItem:NSLayoutRelationEqual
				attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:CGRectGetWidth(rootController.view.frame)]];
	[rootController addChildViewController:self];
	[self didMoveToParentViewController:rootController];
	[rootController.view addSubview:self.view];
	
	[rootController.view addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]|" options:0
				metrics:nil views:@{@"view" : self.view}]];
	
	self.constraint = [NSLayoutConstraint
				constraintWithItem:self.view attribute:NSLayoutAttributeTop
				relatedBy:NSLayoutRelationEqual toItem:rootController.view
				attribute:NSLayoutAttributeTop multiplier:1.
				constant:-constraint.constant];
	[rootController.view addConstraint:self.constraint];
	
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
	[UIApplication sharedApplication].delegate.window.userInteractionEnabled = NO;
	[UIView animateWithDuration:0.25 animations:
	^{
		self.constraint.constant = 0;
		[self.view setNeedsLayout];
		[self.view layoutIfNeeded];
	}
				completion:^(BOOL finished)
	{
		[UIApplication sharedApplication].delegate.window.userInteractionEnabled = YES;
		if (nil != aCompletion)
		{
			aCompletion();
		}
	}];
}

- (void)hideWithCompletion:(void (^)())aCompletion
{
	[UIApplication sharedApplication].delegate.window.userInteractionEnabled = NO;
	[UIView animateWithDuration:0.25 animations:
	^{
		self.constraint.constant = -CGRectGetHeight(self.view.frame);
		[self.view setNeedsLayout];
		[self.view layoutIfNeeded];
	}
				completion:^(BOOL finished)
	{
		[self.view removeFromSuperview];
		[self removeFromParentViewController];
		[UIApplication sharedApplication].delegate.window.userInteractionEnabled = YES;
		if (nil != aCompletion)
		{
			aCompletion();
		}
	}];
}

@end
