//
//  PWPresentByBonusesViewController.h
//  PocketWaiter
//
//  Created by Www Www on 10/1/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWScrollHandlerController.h"
#import "UIViewControllerAdditions.h"

@class PWPresentProduct;
@class PWRestaurant;

@interface PWPresentByBonusesViewController : PWScrollHandlerController

@property (nonatomic) CGSize contentSize;
@property (nonatomic, weak, readonly) id<IPWTransiter> transiter;

- (instancetype)initWithPresents:(NSArray<PWPresentProduct *> *)presents
			restaurant:(PWRestaurant *)restaurant
			scrollHandler:(void (^)(CGPoint velocity))aHandler
			transiter:(id<IPWTransiter>)transiter;

@end
