//
//  PWGridProductsController.h
//  PocketWaiter
//
//  Created by Www Www on 10/1/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWScrollableViewController.h"
#import "UIViewControllerAdditions.h"

@class PWPresentProduct;
@class PWRestaurant;

@interface PWGridProductsController : PWScrollableViewController
			<IPWTransitableController>

@property (nonatomic) CGFloat contentWidth;

- (instancetype)initWithPresents:(NSArray<PWPresentProduct *> *)presents
			restaurant:(PWRestaurant *)restaurant;

@end
