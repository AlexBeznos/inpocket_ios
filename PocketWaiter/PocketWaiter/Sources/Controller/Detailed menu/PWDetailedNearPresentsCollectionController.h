//
//  PWDetailedNearPresentsCollectionController.h
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWDetailedNearItemsCollectionController.h"

@class PWPresentProduct;

@interface PWDetailedNearPresentsCollectionController : PWDetailedNearItemsCollectionController

- (instancetype)initWithPresents:(NSArray<PWPresentProduct *> *)presents
			transiter:(id<IPWTransiter>)transiter;

@end
