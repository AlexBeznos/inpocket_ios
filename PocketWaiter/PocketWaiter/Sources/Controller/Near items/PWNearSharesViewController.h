//
//  PWNearSharesViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWNearItemsViewController.h"

@class PWRestaurantShare;

@interface PWNearSharesViewController : PWNearItemsViewController

- (instancetype)initWithShares:(NSArray<PWRestaurantShare *> *)shares
			scrollHandler:(void (^)(CGPoint velocity))aHandler
			transiter:(id<IPWTransiter>)transiter;

@property (strong, nonatomic) UIColor *colorScheme;

@end
