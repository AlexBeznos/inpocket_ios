//
//  PWRegisterController.m
//  PocketWaiter
//
//  Created by Www Www on 9/5/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWSignInController.h"
#import "PWFacebookManager.h"
#import "PWVKManager.h"
#import "UIColorAdditions.h"
#import "PWRegisterController.h"
#import "UIViewControllerAdditions.h"

@interface PWSignInController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *loginField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UILabel *registerLabel;
@property (strong, nonatomic) IBOutlet UIButton *signInButton;
@property (nonatomic, weak) id<IPWTransiter> transiter;

@property (nonatomic, copy) void (^completion)(PWUser *user);

@end

@implementation PWSignInController

- (instancetype)initWithCompletion:(void (^)(PWUser *user))completion
			transiter:(id<IPWTransiter>)transiter
{
	self = [super init];
	
	if (nil != self)
	{
		self.completion = completion;
		self.transiter = transiter;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.scrollView removeFromSuperview];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	
	self.registerLabel.text = @"Логин";
	self.loginField.placeholder = @"Email";
	self.passwordField.placeholder = @"Пароль";
	[self.signInButton setTitle:@"Нет аккаунта? Зарегистрируйтесь"
				forState:UIControlStateNormal];
	self.passwordField.secureTextEntry = YES;
    
//    for (UIView *subview in self.view.subviews){
//        for (NSLayoutConstraint *constraint in subview.constraints){
//            double coef = 320 / self.view.frame.size.width;
//            constraint.constant = constraint.constant / coef;
//        }
//    }
}

- (IBAction)showHidePassword:(id)sender
{
	self.passwordField.secureTextEntry = !self.passwordField.secureTextEntry;
}

- (IBAction)connectFB:(id)sender
{
	[self startActivity];
	__weak __typeof(self) weakSelf = self;
	[[PWFacebookManager sharedManager] getProfileInfoWithCompletion:
	^(NSDictionary *info, NSError *error)
	{
		if (nil != error)
		{
			[weakSelf stopActivity];
			[weakSelf showNoInternetDialog];
		}
		else if (nil != weakSelf.completion)
		{
			PWUser *user = USER;
			[user updateWithJsonInfo:@{@"facebook_profile" : info}];
			if (nil == user.avatarIcon)
			{
				user.avatarURL = [NSURL URLWithString:info[@"remote_photo_url"]];
			}
			[[PWModelManager sharedManager] signUpWithProvider:@"facebook"
						profile:user.fbProfile completion:
			^(NSError *error)
			{
				[weakSelf stopActivity];
				if (nil != error)
				{
					user.fbProfile = nil;
					[weakSelf showNoInternetDialog];
				}
				else
				{
					weakSelf.completion(user);
				}
			}];
		}
	}];
}

- (IBAction)connectVK:(id)sender
{
	[self startActivity];
	__weak __typeof(self) weakSelf = self;
	[[PWVKManager sharedManager] getProfileInfoWithCompletion:
	^(NSDictionary *info, NSError *error)
	{
		if (nil != error)
		{
			[weakSelf stopActivity];
			[weakSelf showNoInternetDialog];
		}
		else if (nil != weakSelf.completion)
		{
			PWUser *user = USER;
			[user updateWithJsonInfo:@{@"vk_profile" : info}];
			if (nil == user.avatarIcon)
			{
				user.avatarURL = [NSURL URLWithString:info[@"remote_photo_url"]];
			}
			[[PWModelManager sharedManager] signUpWithProvider:@"vk"
						profile:user.vkProfile completion:
			^(NSError *error)
			{
				[weakSelf stopActivity];
				if (nil != error)
				{
					user.vkProfile = nil;
					[weakSelf showNoInternetDialog];
				}
				else
				{
					weakSelf.completion(user);
				}
			}];
		}
	}];
}

- (IBAction)signIn:(id)sender
{
	__weak __typeof(self) weakSelf = self;
	PWRegisterController *registerController = [[PWRegisterController alloc]
				initWithCompletion:
	^{
		[weakSelf.transiter performBackTransition];
	}];
	
	[self.transiter performForwardTransition:registerController];
}

- (IBAction)signUp:(id)sender
{
	NSString *email = self.loginField.text;
	
	NSArray *parts = [email componentsSeparatedByString:@"@"];
	if (parts.count != 2)
	{
		UIAlertController *alert = [UIAlertController
					alertControllerWithTitle:@"Не удалось войти"
					message:@"Неверный формат емеил адресса"
					preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Хорошо"
					style:UIAlertActionStyleDefault handler:nil]];
		self.view.userInteractionEnabled = NO;
		[self presentViewController:alert animated:YES completion:
		^{
			self.view.userInteractionEnabled = YES;
		}];
	}
	else if (self.loginField.text.length > 0 && self.passwordField.text.length > 0)
	{
		[self startActivity];
		
		__weak __typeof(self) weakSelf = self;
		[[PWModelManager sharedManager] signInWithEmail:self.loginField.text
					password:self.passwordField.text completion:
		^(NSError *error)
		{
			[weakSelf stopActivity];
			if (nil != error)
			{
                UIAlertController *alert = [UIAlertController
                                            alertControllerWithTitle:@"Не удалось войти"
                                            message:@"Логин или пароль не верный"
                                            preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Хорошо"
                                                          style:UIAlertActionStyleDefault handler:nil]];
                self.view.userInteractionEnabled = NO;
                [self presentViewController:alert animated:YES completion:
                 ^{
                     self.view.userInteractionEnabled = YES;
                 }];
			}
			else
			{
				PWUser *user = USER;
				[user updateWithJsonInfo:@{@"email" : weakSelf.loginField.text,
							@"password" : weakSelf.passwordField.text}];
				weakSelf.completion(user);
			}
		}];
	}
	else
	{
		UIAlertController *alert = [UIAlertController
					alertControllerWithTitle:@"Не удалось войти"
					message:@"Пароль не может быть пустыми"
					preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Хорошо"
					style:UIAlertActionStyleDefault handler:nil]];
		self.view.userInteractionEnabled = NO;
		[self presentViewController:alert animated:YES completion:
		^{
			self.view.userInteractionEnabled = YES;
		}];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == self.loginField)
	{
		[self.passwordField becomeFirstResponder];
	}
	else
	{
		[textField resignFirstResponder];
	}
	
	return textField == self.passwordField;
}

@end
