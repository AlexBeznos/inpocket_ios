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
	[FBSDKProfile loadCurrentProfileWithCompletion:
	^(FBSDKProfile *profile, NSError *error)
	{
		if (nil != error)
		{
			completion(nil, error);
		}
		else
		{
			NSURL *iconURL = [profile
						imageURLForPictureMode:FBSDKProfilePictureModeSquare
						size:CGSizeMake(100, 100)];
			[[[NSURLSession sharedSession] downloadTaskWithURL:iconURL completionHandler:
			^(NSURL * _Nullable location, NSURLResponse * _Nullable response,
						NSError * _Nullable error)
			{
				NSString *tempPath = [NSTemporaryDirectory() stringByAppendingString:iconURL.lastPathComponent];
				[[NSFileManager defaultManager] moveItemAtPath:location.path toPath:tempPath error:NULL];
				
				completion(
						@{
							@"firstName" : profile.firstName,
							@"lastName" : profile.lastName,
							@"userID" : profile.userID,
							@"image" : [UIImage imageWithContentsOfFile:tempPath]
						}, nil);
			}] resume];
		}
	}];
}

@end
