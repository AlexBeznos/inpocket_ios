//
//  PWRestaurantAboutInfo.m
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRestaurantAboutInfo.h"

@interface PWRestaurantAboutInfo ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSArray<NSString *> *phoneNumbers;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *restaurantDescription;
@property (nonatomic, strong) UIImage *restaurantImage;
@property (nonatomic, strong) NSArray<UIImage *> *photos;
@property (nonatomic, strong) NSArray<PWRestaurantReview *> *reviews;
@property (nonatomic, strong) NSArray<NSString *> *workingPlan;
@property (nonatomic, strong) NSString *logoPath;
@property (nonatomic, strong) NSString *cardImagePath;
@property (nonatomic, strong) NSArray *imagesPaths;
@property (nonatomic) NSUInteger collectedBonuses;
@property (nonatomic, strong) NSString *webLink;

@end

@implementation PWRestaurantAboutInfo

- (instancetype)initWithJSONInfo:(id)jsonInfo
{
	self = [super initWithJSONInfo:jsonInfo];
	
	if (nil != self && [jsonInfo isKindOfClass:[NSDictionary class]])
	{
		NSDictionary *info = (NSDictionary *)jsonInfo;
		self.name = info[@"name"];
		self.phoneNumbers = NOT_NULL(info[@"phones"]) ? info[@"phones"] : nil;
		self.workingPlan = NOT_NULL(info[@"working_hours_decorated"]) ? info[@"working_hours_decorated"] : nil;
		self.webLink = info[@"site"];
		self.restaurantDescription = info[@"description"];
		self.logoPath = info[@"logo"];
		self.cardImagePath = info[@"card_image"];
		self.imagesPaths = info[@"images"];
		CGFloat latitude = [info[@"lat"] floatValue];
		CGFloat longitude = [info[@"lng"] floatValue];
		self.location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
		NSArray *rgb = info[@"color_rgb"];
		self.color = [UIColor colorWithRed:[rgb[0] floatValue] / 255. green:[rgb[1] floatValue]  / 255. blue:[rgb[2] floatValue]  / 255. alpha:1];
		self.category = info[@"category"];
		self.address = info[@"address"];
		self.collectedBonuses = [info[@"score"] integerValue];
	}
	else
	{
		self = nil;
	}
	
	return self;
}

- (UIImage *)restaurantImage
{
	return [UIImage imageWithContentsOfFile:self.downloadedLogoURL];
}

@end
