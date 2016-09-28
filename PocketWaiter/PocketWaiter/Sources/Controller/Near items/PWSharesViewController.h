//
//  PWNearSharesViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWNearItemsViewController.h"

@class PWRestaurantShare;

@interface PWSharesViewController : PWNearItemsViewController

- (instancetype)initWithShares:(NSArray<PWRestaurantShare *> *)shares
			title:(NSString *)title
			scrollHandler:(void (^)(CGPoint velocity))aHandler
			transiter:(id<IPWTransiter>)transiter;

@property (strong, nonatomic) UIColor *colorScheme;

@end
