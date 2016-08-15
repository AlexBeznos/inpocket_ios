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

- (NSString *)name
{
	return self.aboutInfo.name;
}

- (NSString *)address
{
	return self.aboutInfo.address;
}

- (NSString *)phoneNumber
{
	return self.aboutInfo.phoneNumber;
}

- (CLLocation *)location
{
	return self.aboutInfo.location;
}

- (NSString *)restaurantDescription
{
	return self.aboutInfo.restaurantDescription;
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

- (NSArray<PWWorkingTime *> *)workingPlan
{
	return self.aboutInfo.workingPlan;
}

@end
