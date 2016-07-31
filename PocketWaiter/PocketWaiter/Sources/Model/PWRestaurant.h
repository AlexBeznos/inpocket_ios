//
//  PWRestaurant.h
//  PocketWaiter
//
//  Created by Www Www on 7/30/16.
//  Copyright © 2016 Www Www. All rights reserved.
//

#import "PWModelObject.h"

@class PWRestaurantShare;
@class PWRestaurantAboutInfo;

@interface PWRestaurant : PWModelObject

@property (nonatomic, readonly) PWRestaurantAboutInfo *aboutInfo;
@property (nonatomic, readonly) NSArray<PWRestaurantShare *> *shares;

@end
