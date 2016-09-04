//
//  PWSharesMapController.h
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWMapController.h"

@class PWRestaurantShare;

@interface PWSharesMapController : PWMapController

- (instancetype)initWithShares:(NSArray<PWRestaurantShare *> *)shares
			selectedShare:(PWRestaurantShare *)share
			transiter:(id<IPWTransiter>)transiter;

@end
