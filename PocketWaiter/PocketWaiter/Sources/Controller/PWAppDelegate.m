//
//  AppDelegate.m
//  PocketWaiter
//
//  Created by Www Www on 7/29/16.
//  Copyright © 2016 Www Www. All rights reserved.
//

#import "PWAppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <VKSdkFramework/VKSdkFramework.h>

@interface PWAppDelegate ()

@end

@implementation PWAppDelegate

- (BOOL)application:(UIApplication *)application
			didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[GMSServices provideAPIKey:@"AIzaSyBey584OKFmQxy25R_b_K_av16_wxHdvYY"];
	[[FBSDKApplicationDelegate sharedInstance] application:application
                           didFinishLaunchingWithOptions:launchOptions];
	
	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[FBSDKAppEvents activateApp];
}


- (BOOL)application:(UIApplication *)application  openURL:(NSURL *)url
			sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	[VKSdk processOpenURL:url fromApplication:sourceApplication];
	return [[FBSDKApplicationDelegate sharedInstance] application:application
				openURL:url sourceApplication:sourceApplication annotation:annotation];
}


@end
