//
//  PWFacebookManager.m
//  PocketWaiter
//
//  Created by Www Www on 9/10/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWFacebookManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface PWFacebookManager ()

@property (nonatomic, strong) FBSDKLoginManager *loginManager;

@end

@implementation PWFacebookManager

+ (PWFacebookManager *)sharedManager
{
	static PWFacebookManager *manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken,
	^{
		manager = [PWFacebookManager new];
	});

	return manager;
}

- (instancetype)init
{
	self = [super init];
	
	if (nil != self)
	{
		[FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
	}
	
	return self;
}

- (FBSDKLoginManager *)loginManager
{
	if (nil == _loginManager)
	{
		_loginManager = [FBSDKLoginManager new];
		_loginManager.loginBehavior = FBSDKLoginBehaviorSystemAccount;
	}
	
	return _loginManager;
}

- (void)loginFromController:(UIViewController *)controller
			completion:(void (^)(NSString *accessToken, NSError *error))completion
{
	if (nil != completion)
	{
		if ([FBSDKAccessToken currentAccessToken])
		{
			completion([FBSDKAccessToken currentAccessToken].tokenString, nil);
		}
		else
		{
			[self.loginManager logInWithReadPermissions:
						@[@"public_profile"]
						fromViewController:controller handler:
			^(FBSDKLoginManagerLoginResult *result, NSError *error)
			{
				if ([result.grantedPermissions containsObject:@"public_profile"] &&
							nil != result)
				{
					completion(result.token.tokenString, nil);
				}
				else
				{
					completion(nil, nil != error ? error :
								[NSError errorWithDomain:@"FBLogin" code:-1 userInfo:nil]);
				}
			}];
		}
	}
}

- (void)getProfileInfoWithCompletion:(void (^)(NSDictionary *info, NSError *error))completion
{
	if (nil != completion)
	{
		if ([FBSDKAccessToken currentAccessToken])
		{
			[self loadProfileWithCompletion:completion];
		}
		else
		{
			__weak __typeof(self) weakSelf = self;
			[self loginFromController:[UIApplication sharedApplication].delegate.window.rootViewController completion:
			^(NSString *accessToken, NSError *error)
			{
				if (nil != error)
				{
					completion(nil, error);
				}
				else
				{
					[weakSelf loadProfileWithCompletion:completion];
				}
			}];
		}
	}
}

- (void)loadProfileWithCompletion:(void (^)(NSDictionary *info, NSError *error))completion
{
	__weak __typeof(self) weakSelf = self;
	[FBSDKProfile loadCurrentProfileWithCompletion:
	^(FBSDKProfile *profile, NSError *error)
	{
		if (nil != error)
		{
			completion(nil, error);
		}
		else
		{
			NSMutableDictionary *currentInfo = [weakSelf infoFromProfile:profile];
			
			NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
			[parameters setValue:@"id,name,email,gender" forKey:@"fields"];

			[[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
						startWithCompletionHandler:
			^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
			{
				if (nil == error)
				{
					NSDictionary *resultInfo = (NSDictionary *)result;
					if (nil != resultInfo[@"gender"])
					{
						currentInfo[@"gender"] = resultInfo[@"gender"];
					}
					
					if (nil != resultInfo[@"email"])
					{
						currentInfo[@"email"] = resultInfo[@"email"];
					}
				}
				
				completion(currentInfo, nil);
			}];
		}
	}];
}

- (NSMutableDictionary *)infoFromProfile:(FBSDKProfile *)profile
{
	NSMutableDictionary *info = [NSMutableDictionary dictionary];
	
	if (nil != profile.firstName && nil != profile.lastName)
	{
		info[@"username"] = [NSString stringWithFormat:@"%@ %@",
					profile.firstName, profile.lastName];
	}
	
	if (nil != profile.userID)
	{
		info[@"uid"] = profile.userID;
	}
	
	NSURL *url = [profile imageURLForPictureMode:FBSDKProfilePictureModeSquare
				size:CGSizeMake(100, 100)];
	
	if (nil != url)
	{
		info[@"remote_photo_url"] = url.absoluteString;
	}
	
	return info;
}

@end
