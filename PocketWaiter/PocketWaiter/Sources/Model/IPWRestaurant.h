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
@class PWWorkingTime;

@protocol IPWRestaurant <NSObject>

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *address;
@property (nonatomic, readonly) NSString *phoneNumber;
@property (nonatomic, readonly) CLLocation *location;
@property (nonatomic, readonly) NSString *restaurantDescription;
@property (nonatomic, readonly) UIImage *restaurantImage;
@property (nonatomic, readonly) NSArray<UIImage *> *photos;
@property (nonatomic, readonly) NSArray<PWRestaurantReview *> *reviews;
@property (nonatomic, readonly) NSArray<PWWorkingTime *> *workingPlan;

@end