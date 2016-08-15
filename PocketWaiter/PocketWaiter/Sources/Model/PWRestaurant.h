//
//  PWRestaurant.h
//  PocketWaiter
//
//  Created by Www Www on 7/30/16.
//  Copyright © 2016 Www Www. All rights reserved.
//

#import "PWModelObject.h"
#import "IPWRestaurant.h"

@class PWRestaurantShare;
@class PWRestaurantAboutInfo;
@class PWProduct;
@class PWPresentProduct;

@interface PWRestaurant : PWModelObject <IPWRestaurant>

@property (nonatomic, readonly) PWRestaurantAboutInfo *aboutInfo;
@property (nonatomic, readonly) NSArray<PWRestaurantShare *> *shares;
@property (nonatomic, readonly) NSArray<PWProduct *> *products;
@property (nonatomic, readonly) NSArray<PWPresentProduct *> *presents;
@property (nonatomic, readonly) NSArray<PWProduct *> *firstPresents;
@property (nonatomic, readonly) NSArray<PWProduct *> *bestForDay;

@end
