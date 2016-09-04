//
//  PWPurchase.h
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWModelObject.h"

@class PWOrder;

@interface PWPurchase : PWModelObject

@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) NSArray<PWOrder *> *orders;
@property (nonatomic, readonly) NSArray<PWOrder *> *presents;
@property (nonatomic, readonly) NSString *restaurantId;

@property (nonatomic, readonly) NSUInteger bonusesCount;

@end
