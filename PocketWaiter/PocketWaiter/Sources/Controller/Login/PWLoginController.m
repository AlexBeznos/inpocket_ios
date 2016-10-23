//
//  PWLoginController.m
//  PocketWaiter
//
//  Created by Www Www on 9/5/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWLoginController.h"
#import "PWSignInController.h"
#import "PWProfileController.h"

@interface PWLoginController ()

@end

@implementation PWLoginController

@synthesize name;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self startActivity];
	
	__weak __typeof(self) weakSelf = self;
	[[PWModelManager sharedManager] getUserInfoWithCompletion:^(PWUser *user, NSError *error)
	{
		[weakSelf stopActivity];
		if (nil != error)
		{
			[weakSelf showNoInternetDialog];
		}
		else
		{
			if (nil == user.vkProfile && nil == user.fbProfile && nil == user.email)
			{
				PWSignInController *signInController = [[PWSignInController alloc]
							initWithCompletion:^(PWUser *user)
				{
					if (nil != user)
					{
						[weakSelf showProfile];
					}
				} transiter:self];
				
				[self setupChildController:signInController inView:self.view];
			}
			else
			{
				[weakSelf showProfile];
			}
		}
	}];
}

- (void)showProfile
{
	name = @"Настройки";
	[self setupNavigation];
	PWProfileController *profileController = [[PWProfileController alloc] initWithStyle:UITableViewStyleGrouped];
	
	[self setupChildController:profileController inView:self.view];
}

@end
