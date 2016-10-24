//
//  PWOwnedObject.h
//  PocketWaiter
//
//  Created by Www Www on 10/24/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWModelObject.h"
#import "IPWRestaurant.h"

@interface PWOwnedObject : PWModelObject

@property (nonatomic, readonly) NSString *distance;
@property (nonatomic, readonly) NSNumber *ownerId;
@property (nonatomic, readonly) NSString *ownerName;

@property (nonatomic, readonly) id<IPWRestaurant> restaurant;

@end
