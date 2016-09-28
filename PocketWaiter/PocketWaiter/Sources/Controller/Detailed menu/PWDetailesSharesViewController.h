//
//  PWDetailesSharesViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWDetailesItemsViewController.h"

@class PWRestaurantShare;

@interface PWDetailesSharesViewController : PWDetailesItemsViewController

- (instancetype)initWithShares:(NSArray<PWRestaurantShare *> *)shares
			listOnly:(BOOL)listOnly;

@end
