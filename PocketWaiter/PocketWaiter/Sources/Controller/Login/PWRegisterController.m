//
//  PWRegisterController.m
//  PocketWaiter
//
//  Created by Www Www on 9/5/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRegisterController.h"
#import "UIColorAdditions.h"

@interface PWRegisterController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *loginField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UILabel *registerLabel;

@property (nonatomic, copy) void (^completion)();

@end

@implementation PWRegisterController

@synthesize transiter;

- (instancetype)initWithCompletion:(void (^)())completion
{
	self = [super init];
	
	if (nil != self)
	{
		self.completion = completion;
	}
	
	return self;
}

- (void)transitionBack
{
	[self.transiter performBackTransition];
}

- (void)setupWithNavigationItem:(UINavigationItem *)item
{
	[self setupBackItemWithTarget:self action:@selector(transitionBack)
				navigationItem:item];
	item.rightBarButtonItems = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.scrollView removeFromSuperview];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	
	self.registerLabel.text = @"Зарегистрироваться";
	self.loginField.placeholder = @"Email";
	self.passwordField.placeholder = @"Пароль";
	self.passwordField.secureTextEntry = YES;
}

- (IBAction)showHidePassword:(id)sender
{
	self.passwordField.secureTextEntry = !self.passwordField.secureTextEntry;
}

- (IBAction)signUp:(id)sender
{
	NSString *email = self.loginField.text;
	
	NSArray *parts = [email componentsSeparatedByString:@"@"];
	if (parts.count != 2)
	{
		UIAlertController *alert = [UIAlertController
					alertControllerWithTitle:@"Не удалось зарегистрировать пользователя"
					message:@"Неверный формат емеил адресса"
					preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Хорошо" style:UIAlertActionStyleDefault handler:nil]];
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
		[[PWModelManager sharedManager] registerUserWithEmail:self.loginField.text
					password:self.passwordField.text completion:
		^(NSError *error)
		{
			if (nil != error)
			{
				[weakSelf showNoInternetDialog];
			}
			else
			{
				UIAlertController *alert = [UIAlertController
							alertControllerWithTitle:@"Спасибо за регистрацию"
							message:@"Теперь войдите в систему"
							preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"Хорошо"
							style:UIAlertActionStyleDefault handler:
				^(UIAlertAction *action)
				{
					if (nil != weakSelf.completion)
					{
						weakSelf.completion();
					}
				}]];
				self.view.userInteractionEnabled = NO;
				[self presentViewController:alert animated:YES completion:
				^{
					self.view.userInteractionEnabled = YES;
				}];
			}
		}];
	}
	else
	{
		UIAlertController *alert = [UIAlertController
					alertControllerWithTitle:@"Не удалось зарегистрировать пользователя"
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
