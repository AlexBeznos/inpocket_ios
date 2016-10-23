//
//  PWRegisterController.m
//  PocketWaiter
//
//  Created by Www Www on 9/5/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRegisterController.h"
#import "PWFacebookManager.h"
#import "PWVKManager.h"
#import "UIColorAdditions.h"

@interface PWRegisterController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *loginField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UILabel *registerLabel;
@property (strong, nonatomic) IBOutlet UIButton *signInButton;

@property (nonatomic, copy) void (^completion)(PWUser *user);

@end

@implementation PWRegisterController

- (instancetype)initWithCompletion:(void (^)(PWUser *user))completion
{
	self = [super init];
	
	if (nil != self)
	{
		self.completion = completion;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.scrollView removeFromSuperview];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	
	self.registerLabel.text = @"Зарегистрироваться";
	self.loginField.placeholder = @"Email";
	self.passwordField.placeholder = @"Пароль";
	[self.signInButton setTitle:@"Есть аккаунт? Войдите в систему" forState:UIControlStateNormal];
	self.passwordField.secureTextEntry = YES;
}

- (IBAction)showHidePassword:(id)sender
{
	self.passwordField.secureTextEntry = !self.passwordField.secureTextEntry;
}

- (IBAction)connectFB:(id)sender
{
	__weak __typeof(self) weakSelf = self;
	[[PWFacebookManager sharedManager] getProfileInfoWithCompletion:
	^(NSDictionary *info, NSError *error)
	{
		if (nil != error)
		{
			[weakSelf showNoInternetDialog];
		}
		else if (nil != weakSelf.completion)
		{
			PWUser *user = USER;
			user.fbProfile = [[PWSocialProfile alloc] initWithUuid:info[@"userID"]
						email:info[@"email"] gender:info[@"gender"]
						name:info[@"userName"]];
			if (nil == user.avatarIcon)
			{
				user.avatarURL = info[@"iconURL"];
			}
			weakSelf.completion(user);
		}
	}];
}

- (IBAction)connectVK:(id)sender
{
	__weak __typeof(self) weakSelf = self;
	[[PWVKManager sharedManager] getProfileInfoWithCompletion:
	^(NSDictionary *info, NSError *error)
	{
		if (nil != error)
		{
			[weakSelf showNoInternetDialog];
		}
		else if (nil != weakSelf.completion)
		{
			PWUser *user = USER;
			user.vkProfile = [[PWSocialProfile alloc] initWithUuid:info[@"userID"]
						email:info[@"email"] gender:info[@"gender"]
						name:info[@"userName"]];
			if (nil == user.avatarIcon)
			{
				user.avatarURL = info[@"iconURL"];
			}
			weakSelf.completion(user);
		}
	}];
}

- (IBAction)signIn:(id)sender {
}
- (IBAction)signUp:(id)sender {
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
