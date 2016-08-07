//
//  PWOrder.h
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWModelObject.h"

@class PWProduct;

@interface PWOrder : PWModelObject

@property (nonatomic, strong) PWProduct *product;
@property (nonatomic) NSUInteger count;

@end
