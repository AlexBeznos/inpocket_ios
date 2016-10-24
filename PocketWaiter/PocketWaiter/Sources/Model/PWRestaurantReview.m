//
//  PWRestaurantReview.m
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRestaurantReview.h"

@interface PWRestaurantReview ()

@property (nonatomic, strong) UIImage *userIcon;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *reviewDescription;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) NSString *photoPath;
@property (nonatomic, strong) NSString *userIconPath;

@end

@implementation PWRestaurantReview

- (instancetype)initWithCommentbody:(NSString *)body image:(UIImage *)image
{
	self = [super init];
	
	if (nil != self)
	{
		self.photo = image;
		self.reviewDescription = body;
	}
	
	return self;
}

- (instancetype)initWithJSONInfo:(id)jsonInfo
{
	self = [super initWithJSONInfo:jsonInfo];
	
	if (nil != self && [jsonInfo isKindOfClass:[NSDictionary class]])
	{
		NSDictionary *info = (NSDictionary *)jsonInfo;
		self.reviewDescription = info[@"content"];
		self.photoPath = info[@"image"];
		self.rank = [info[@"stars"] integerValue];
		if (nil != info[@"created_at"])
		{
			self.date = [NSDate dateWithTimeIntervalSince1970:
						[info[@"created_at"] integerValue]];
		}
		if (NOT_NULL(info[@"user"]))
		{
			NSDictionary *userInfo = info[@"user"];
			if (nil != userInfo[@"first_name"] && nil != userInfo[@"last_name"])
			{
				self.userName = [NSString stringWithFormat:@"%@ %@",
							userInfo[@"first_name"], userInfo[@"last_name"]];
			}
			
			self.userIconPath = userInfo[@"photo"];
		}
	}
	else
	{
		self = nil;
	}
	
	return self;
}

@end
