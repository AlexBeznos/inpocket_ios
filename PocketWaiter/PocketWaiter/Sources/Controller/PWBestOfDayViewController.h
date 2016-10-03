//
//  PWBestOfDayViewController.h
//  PocketWaiter
//
//  Created by Www Www on 10/3/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWScrollHandlerController.h"

@protocol IPWTransiter;
@class PWProduct;
@class PWRestaurant;

@interface PWBestOfDayViewController : PWScrollHandlerController

@property (nonatomic) CGSize contentSize;
@property (nonatomic, weak, readonly) id<IPWTransiter> transiter;

- (instancetype)initWithProducts:(NSArray<PWProduct *> *)products
			restaurant:(PWRestaurant *)restaurant
			scrollHandler:(void (^)(CGPoint velocity))aHandler
			transiter:(id<IPWTransiter>)transiter;

@end
