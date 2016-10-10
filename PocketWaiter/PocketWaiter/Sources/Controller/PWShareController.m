//
//  PWShareController.m
//  PocketWaiter
//
//  Created by Www Www on 10/10/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWShareController.h"

@implementation PWShareController

+ (void)shareText:(NSString *)text image:(UIImage *)image completion:(void (^)(NSError *error))completion
{
	NSMutableArray *objectsToShare = [NSMutableArray array];
	if (nil != text)
	{
		[objectsToShare addObject:text];
	}
	
	if (nil != image)
	{
		[objectsToShare addObject:image];
	}
 
	UIActivityViewController *activityVC = [[UIActivityViewController alloc]
				initWithActivityItems:objectsToShare applicationActivities:nil];
 
	NSArray *excludeActivities = @[UIActivityTypeAirDrop, UIActivityTypePrint,
				UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
				UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
				UIActivityTypePostToVimeo];
 
	activityVC.excludedActivityTypes = excludeActivities;
	activityVC.completionWithItemsHandler = ^(NSString * __nullable activityType,
				BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError)
	{
		if (nil != completion)
		{
			completion(activityError);
		}
	};
	
	[UIApplication sharedApplication].delegate.window.userInteractionEnabled = NO;
	[[UIApplication sharedApplication].delegate.window.rootViewController
				presentViewController:activityVC animated:YES completion:
	^{
		[UIApplication sharedApplication].delegate.window.userInteractionEnabled = YES;
	}];
}

@end
