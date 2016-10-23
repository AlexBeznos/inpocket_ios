//
//  PWLoginController.m
//  PocketWaiter
//
//  Created by Www Www on 9/5/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWLoginController.h"
#import "PWRegisterController.h"

@interface PWLoginController ()

@end

@implementation PWLoginController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	PWUser *user = USER;
	
	if (nil == user.vkProfile && nil == user.fbProfile && nil == user.userName)
	{
		PWRegisterController *registerController = [[PWRegisterController alloc]
					initWithCompletion:^(PWUser *user)
		{
			if (nil != user)
			{
				
			}
		}];
		
		[self setupChildController:registerController inView:self.view];
	}
	else
	{
	
	}
}

@end
