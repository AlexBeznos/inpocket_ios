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
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *restaurantDescription;
@property (nonatomic, strong) UIImage *restaurantImage;
@property (nonatomic, strong) NSArray<UIImage *> *photos;
@property (nonatomic, strong) NSArray<PWRestaurantReview *> *reviews;
@property (nonatomic, strong) NSArray<PWWorkingTime *> *workingPlan;

@end

@implementation PWRestaurantAboutInfo

@end
