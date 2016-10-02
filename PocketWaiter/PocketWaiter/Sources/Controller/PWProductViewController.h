//
//  PWPresentByBonusesViewController.h
//  PocketWaiter
//
//  Created by Www Www on 10/1/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWScrollHandlerController.h"
#import "UIViewControllerAdditions.h"

@class PWProduct;
@class PWRestaurant;

@interface PWProductViewController : PWScrollHandlerController

@property (nonatomic) CGSize contentSize;
@property (nonatomic, weak, readonly) id<IPWTransiter> transiter;

- (instancetype)initWithProducts:(NSArray<PWProduct *> *)products
			restaurant:(PWRestaurant *)restaurant
			scrollHandler:(void (^)(CGPoint velocity))aHandler
			transiter:(id<IPWTransiter>)transiter title:(NSString *)title isPresents:(BOOL)isPresent;

@end
