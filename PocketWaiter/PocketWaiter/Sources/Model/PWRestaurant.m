//
//  PWRestaurant.m
//  PocketWaiter
//
//  Created by Www Www on 7/30/16.
//  Copyright © 2016 Www Www. All rights reserved.
//

#import "PWRestaurant.h"
#import "PWProduct.h"
#import "PWRestaurantAboutInfo.h"

@interface PWRestaurant ()

@property (nonatomic, strong) PWRestaurantAboutInfo *aboutInfo;
@property (nonatomic, strong) NSArray<PWRestaurantShare *> *shares;
@property (nonatomic, strong) NSArray<PWProduct *> *products;
@property (nonatomic, strong) NSArray<PWPresentProduct *> *presents;

@end

@implementation PWRestaurant

@synthesize thumbnail = _thumbnail;

- (instancetype)initWithJSONInfo:(id)jsonInfo
{
	self = [super initWithJSONInfo:jsonInfo];
	
	if (nil != self && [jsonInfo isKindOfClass:[NSDictionary class]])
	{
		self.aboutInfo = [[PWRestaurantAboutInfo alloc] initWithJSONInfo:jsonInfo];
	}
	else
	{
		self = nil;
	}
	
	return self;
}

- (NSArray<PWProduct *> *)firstPresents
{
	NSMutableArray *presents = [NSMutableArray new];
	
	for (PWProduct *product in self.products)
	{
		if (0 != (product.type & kPWProductTypeFirstPresent))
		{
			[presents addObject:product];
		}
	}
	
	return presents;
}

- (NSArray<PWProduct *> *)bestForDay
{
	NSMutableArray *presents = [NSMutableArray new];
	
	for (PWProduct *product in self.products)
	{
		if (0 != (product.type & kPWProductTypeBestForDay))
		{
			[presents addObject:product];
		}
	}
	
	return presents;
}

- (NSString *)restaurantName
{
	return self.aboutInfo.name;
}

- (NSString *)address
{
	return self.aboutInfo.address;
}

- (NSArray<NSString *> *)phoneNumbers
{
	return self.aboutInfo.phoneNumbers;
}

- (CLLocation *)location
{
	return self.aboutInfo.location;
}

- (NSString *)restaurantDescription
{
	return self.aboutInfo.restaurantDescription;
}

- (NSString *)logoPath
{
	return self.aboutInfo.logoPath;
}

- (NSUInteger)collectedBonuses
{
	return [self.aboutInfo collectedBonuses];
}

- (NSString *)downloadedLogoURL
{
	return self.aboutInfo.downloadedLogoURL;
}

- (void)setDownloadedLogoURL:(NSString *)downloadedLogoURL
{
	self.aboutInfo.downloadedLogoURL = downloadedLogoURL;
}

- (UIImage *)thumbnail
{
	if (nil == _thumbnail && nil != self.restaurantImage)
	{
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(24, 24), NO, 0);
		[self.restaurantImage drawInRect:CGRectMake(0, 0, 24, 24)];
		_thumbnail = UIGraphicsGetImageFromCurrentImageContext();
	
		UIGraphicsEndImageContext();
	}
	
	return _thumbnail;
}

- (UIImage *)restaurantImage
{
	return self.aboutInfo.restaurantImage;
}

- (NSArray<UIImage *> *)photos
{
	return self.aboutInfo.photos;
}

- (NSArray<PWRestaurantReview *> *)reviews
{
	return self.aboutInfo.reviews;
}

- (NSArray<NSString *> *)workingPlan
{
	return self.aboutInfo.workingPlan;
}

- (UIColor *)color
{
	return self.aboutInfo.color;
}

@end
