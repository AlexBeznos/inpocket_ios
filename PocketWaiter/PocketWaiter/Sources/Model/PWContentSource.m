//
//  PWContentSource.m
//  PocketWaiter
//
//  Created by Www Www on 8/6/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWContentSource.h"

@implementation PWContentSource

- (instancetype)initWithTitle:(NSString *)title details:(NSString *)details
			icon:(UIImage *)icon contentViewController:
			(UIViewController<IPWContentTransitionControler> *)controller
{
	self = [super init];
	
	if (nil != self)
	{
		_title = title;
		_details = details;
		_icon = icon;
		_contentViewController = controller;
	}
	
	return self;
}

@end
