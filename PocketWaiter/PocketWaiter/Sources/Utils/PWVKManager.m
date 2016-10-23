//
//  PWVKManager.m
//  PocketWaiter
//
//  Created by Www Www on 10/23/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWVKManager.h"
#import <VKSdkFramework/VKSdkFramework.h>

@interface PWVKManager () <VKSdkDelegate, VKSdkUIDelegate>

@property (nonatomic, copy) void (^authCompletion)(NSString *accessToken, NSError *error);
@property (nonatomic, strong) UIViewController *presentationController;

@end

@implementation PWVKManager

+ (PWVKManager *)sharedManager
{
	static PWVKManager *manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken,
	^{
		manager = [PWVKManager new];
	});

	return manager;
}

- (instancetype)init
{
	self = [super init];
	
	if (nil != self)
	{
		VKSdk *sdkInstance = [VKSdk initializeWithAppId:@"5679830"];
		[sdkInstance setUiDelegate:self];
		[sdkInstance registerDelegate:self];
	}
	
	return self;
}

- (void)loginFromController:(UIViewController *)controller
			completion:(void (^)(NSString *accessToken, NSError *error))completion
{
	self.presentationController = controller;
	NSArray *SCOPE = @[@"friends", @"email"];
	__weak __typeof(self) weakSelf = self;
	[VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *err)
	{
		if (state == VKAuthorizationAuthorized)
		{
			if (nil != completion)
			{
				completion([[VKSdk accessToken] accessToken], nil);
			}
		}
		else
		{
			weakSelf.authCompletion = completion;
			[VKSdk authorize:SCOPE];
		}
	}];
}

- (void)getProfileInfoWithCompletion:(void (^)(NSDictionary *info, NSError *error))completion
{
	if (nil != completion)
	{
		VKUser *userInfo = [[VKSdk accessToken] localUser];
		if (nil != userInfo)
		{
			completion([self infoFromUser:userInfo], nil);
		}
		else
		{
			__weak __typeof(self) weakSelf = self;
			[self loginFromController:nil completion:
						^(NSString *accessToken, NSError *error)
			{
				if (nil == error)
				{
					if (nil != [[VKSdk accessToken] localUser])
					{
						completion([weakSelf infoFromUser: [[VKSdk accessToken] localUser]], nil);
					}
					else
					{
						VKRequest *usersReq = [[VKApi users] get];
						[usersReq executeWithResultBlock:
						^(VKResponse *response)
						{
							completion([weakSelf infoFromUser: [[VKSdk accessToken] localUser]], nil);
						}
									errorBlock:
						^(NSError *error)
						{
							completion(nil, error);
						}];
					}
				}
				else
				{
					completion(nil, error);
				}
			}];
		}
	}
}

- (NSDictionary *)infoFromUser:(VKUser *)user
{
	NSMutableDictionary *info = [NSMutableDictionary dictionary];
	if (nil != user.domain)
	{
		info[@"email"] = user.domain;
	}
	
	if (nil != user.first_name && nil != user.last_name)
	{
		info[@"username"] = [NSString stringWithFormat:@"%@ %@",
					user.first_name, user.last_name];
	}
	
	if (nil != user.id)
	{
		info[@"uid"] = [user.id stringValue];
	}
	
	if (nil != user.sex)
	{
		info[@"gender"] = [user.sex isEqualToNumber:@1] ? @"male" : @"female";
	}
	
	if (nil != user.photo_100)
	{
		info[@"remote_photo_url"] = user.photo_100;
	}
	
	return info;
}

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result
{
	if (nil != self.authCompletion)
	{
		self.authCompletion([result.token accessToken], nil);
	}
}

- (void)vkSdkUserAuthorizationFailed
{
	if (nil != self.authCompletion)
	{
		self.authCompletion(nil, [NSError errorWithDomain:@"VKAuth"
					code:-1 userInfo:nil]);
	}
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller
{
	UIViewController *presentationController =  nil != self.presentationController ?
				self.presentationController : [UIApplication sharedApplication].delegate.window.rootViewController;
	
	[presentationController presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError
{
}

@end
