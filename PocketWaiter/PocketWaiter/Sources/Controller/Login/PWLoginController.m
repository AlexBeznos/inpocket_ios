//
//  PWLoginController.m
//  PocketWaiter
//
//  Created by Www Www on 9/5/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWLoginController.h"
#import "PWSignInController.h"

@interface PWLoginController ()

@end

@implementation PWLoginController

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
						
					}
				} transiter:self];
				
				[self setupChildController:signInController inView:self.view];
			}
			else
			{
			
			}
		}
	}];
}

@end
