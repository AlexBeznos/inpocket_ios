//
//  PWPurchase.h
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWModelObject.h"

@class PWOrder;
@class PWPrice;
@class PWPresentProduct;

@interface PWPurchase : PWModelObject

- (instancetype)initWithFirstPresent:(PWPresentProduct *)present;

@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) NSArray<PWOrder *> *orders;
@property (nonatomic, readonly) NSArray<PWOrder *> *presents;
@property (nonatomic, readonly) NSString *restaurantId;

@property (nonatomic, readonly) PWPrice *totalPrice;

@property (nonatomic, readonly) NSUInteger bonusesCount;

@end
