//
//  PWUsersRestaurantInfo.h
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWModelObject.h"

@interface PWUsersRestaurantInfo : PWModelObject

@property (nonatomic, readonly) NSString *restaurantId;
@property (nonatomic, readonly) NSDate *lastCommingDate;
@property (nonatomic, readonly) NSUInteger collectedBonuses;
@property (nonatomic, readonly) NSString *sessionToken;

@end
