//
//  PWRestaurantShare.m
//  PocketWaiter
//
//  Created by Www Www on 7/30/16.
//  Copyright © 2016 Www Www. All rights reserved.
//

#import "PWRestaurantShare.h"

@interface PWRestaurantShare ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *shareDescription;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imagePath;

@end

@implementation PWRestaurantShare

- (instancetype)initWithJSONInfo:(id)jsonInfo
{
	self = [super initWithJSONInfo:jsonInfo];
	
	if (nil != self && [jsonInfo isKindOfClass:[NSDictionary class]])
	{
		NSDictionary *info = (NSDictionary *)jsonInfo;
		self.name = info[@"name"];
		self.imagePath = info[@"image"];
		self.shareDescription = info[@"description"];
	}
	else
	{
		self = nil;
	}
	
	return self;
}

- (UIImage *)image
{
	return [UIImage imageWithContentsOfFile:self.downloadedImagePath];
}

@end
