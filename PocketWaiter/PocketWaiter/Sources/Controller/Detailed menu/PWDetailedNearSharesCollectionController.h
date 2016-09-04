//
//  PWDetailedNearSharesCollectionController.h
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWDetailedNearItemsCollectionController.h"

@class PWRestaurantShare;

@interface PWDetailedNearSharesCollectionController : PWDetailedNearItemsCollectionController

- (instancetype)initWithShares:(NSArray<PWRestaurantShare *> *)shares
			transiter:(id<IPWTransiter>)transiter;

@end
