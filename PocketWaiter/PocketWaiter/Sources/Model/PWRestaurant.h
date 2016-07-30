//
//  PWRestaurant.h
//  PocketWaiter
//
//  Created by Www Www on 7/30/16.
//  Copyright © 2016 Www Www. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PWRestaurantShare;

@interface PWRestaurant : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSArray<PWRestaurantShare *> *shares;

@end
