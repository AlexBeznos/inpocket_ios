//
//  IPWRestaurant.h
//  PocketWaiter
//
//  Created by Www Www on 8/15/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class PWRestaurantReview;

@protocol IPWRestaurant <NSObject>

@property (nonatomic, readonly) NSString *restaurantName;
@property (nonatomic, readonly) NSString *address;
@property (nonatomic, readonly) NSArray<NSString *> *phoneNumbers;
@property (nonatomic, readonly) CLLocation *location;
@property (nonatomic, readonly) NSString *restaurantDescription;
@property (nonatomic, readonly) UIImage *restaurantImage;
@property (nonatomic, readonly) UIImage *thumbnail;
@property (nonatomic, readonly) UIColor *color;
@property (nonatomic, readonly) NSArray<UIImage *> *photos;
@property (nonatomic, readonly) NSArray<PWRestaurantReview *> *reviews;
@property (nonatomic, readonly) NSArray<NSString *> *workingPlan;

@property (nonatomic, readonly) NSString *logoPath;
@property (nonatomic, strong) NSString *downloadedLogoURL;
@property (nonatomic, readonly) NSUInteger collectedBonuses;

@end
