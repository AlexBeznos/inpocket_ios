//
//  PWRegisterController.m
//  PocketWaiter
//
//  Created by Www Www on 9/5/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRegisterController.h"
#import "PWFacebookManager.h"

@interface PWRegisterController ()

@property (strong, nonatomic) IBOutlet UITextField *loginField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UILabel *registerLabel;

@end

@implementation PWRegisterController

@synthesize transitedController;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.registerLabel.text = @"Зарегистрироваться";
	self.loginField.placeholder = @"Email";
	self.passwordField.placeholder = @"Пароль";
	self.passwordField.secureTextEntry = YES;
}

- (IBAction)showHidePassword:(id)sender
{
	self.passwordField.secureTextEntry = !self.passwordField.secureTextEntry;
}

- (IBAction)connectFB:(id)sender
{
	[[PWFacebookManager sharedManager] getProfileInfoWithCompletion:
	^(NSDictionary *info, NSError *error) {
		
	}];
}

- (IBAction)connectVK:(id)sender {
}

- (IBAction)signIn:(id)sender {
}
- (IBAction)signUp:(id)sender {
}

@end
