//
//  PWRestaurantAboutInfo.h
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWModelObject.h"
#import <CoreLocation/CoreLocation.h>

@class PWRestaurantReview;

@interface PWRestaurantAboutInfo : PWModelObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *category;
@property (nonatomic, readonly) NSString *address;
@property (nonatomic, readonly) UIColor *color;
@property (nonatomic, readonly) NSArray<NSString *> *phoneNumbers;
@property (nonatomic, readonly) NSString *webLink;
@property (nonatomic, readonly) CLLocation *location;
@property (nonatomic, readonly) NSString *restaurantDescription;
@property (nonatomic, readonly) UIImage *restaurantImage;
@property (nonatomic, readonly) NSArray<UIImage *> *photos;
@property (nonatomic, readonly) NSArray<PWRestaurantReview *> *reviews;
@property (nonatomic, readonly) NSArray<NSString *> *workingPlan;

@property (nonatomic, readonly) NSString *logoPath;
@property (nonatomic, readonly) NSString *cardImagePath;
@property (nonatomic, readonly) NSArray *imagesPaths;
@property (nonatomic, strong) NSString *downloadedLogoURL;
@property (nonatomic, readonly) NSUInteger collectedBonuses;

@end
