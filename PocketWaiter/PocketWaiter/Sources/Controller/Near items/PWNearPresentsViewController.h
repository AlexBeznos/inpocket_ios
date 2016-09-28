//
//  PWNearPresentsViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWNearItemsViewController.h"

@class PWPresentProduct;

@interface PWNearPresentsViewController : PWNearItemsViewController

- (instancetype)initWithPresents:(NSArray<PWPresentProduct *> *)presents
			scrollHandler:(void (^)(CGPoint velocity))aHandler
			transiter:(id<IPWTransiter>)transiter;

@end
