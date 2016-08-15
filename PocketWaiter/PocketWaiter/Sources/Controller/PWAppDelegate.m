//
//  AppDelegate.m
//  PocketWaiter
//
//  Created by Www Www on 7/29/16.
//  Copyright © 2016 Www Www. All rights reserved.
//

#import "PWAppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>

@interface PWAppDelegate ()

@end

@implementation PWAppDelegate

- (BOOL)application:(UIApplication *)application
			didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[GMSServices provideAPIKey:@"AIzaSyBey584OKFmQxy25R_b_K_av16_wxHdvYY"];
	
	return YES;
}


@end
