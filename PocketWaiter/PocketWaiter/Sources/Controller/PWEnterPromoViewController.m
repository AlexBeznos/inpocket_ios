//
//  PWEnterPromoViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/6/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWEnterPromoViewController.h"

@interface PWEnterPromoViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *notHaveButton;
@property (strong, nonatomic) IBOutlet UIButton *agreeButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation PWEnterPromoViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.titleLabel.text = @"Промо код";
	self.descriptionLabel.text = @"Если ваш друг выслал вам промо код регистрации - введите его и вы оба получите по 50 бонусов!";
	self.textField.placeholder = @"Введите ваш промо код";
	[self.notHaveButton setTitle:@"Нет кода" forState:UIControlStateNormal];
	[self.agreeButton setTitle:@"Готово" forState:UIControlStateNormal];
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
	
	self.topConstraint.constant = -464;//134
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
	
	[UIView animateWithDuration:0.25 animations:
	^{
		self.topConstraint.constant = 134;
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
		self.topConstraint.constant = -464;
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

- (IBAction)pressAgree:(id)sender
{
	[self hideWithCompletion:nil];
}

- (IBAction)pressNotHave:(id)sender
{
	[self hideWithCompletion:nil];
}

@end
