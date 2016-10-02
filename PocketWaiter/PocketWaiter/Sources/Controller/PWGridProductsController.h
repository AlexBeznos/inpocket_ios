//
//  PWGridProductsController.h
//  PocketWaiter
//
//  Created by Www Www on 10/1/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWScrollableViewController.h"
#import "UIViewControllerAdditions.h"

@class PWProduct;
@class PWRestaurant;

@interface PWGridProductsController : PWScrollableViewController
			<IPWTransitableController>

@property (nonatomic) CGFloat contentWidth;

- (instancetype)initWithProducts:(NSArray<PWProduct *> *)products
			restaurant:(PWRestaurant *)restaurant title:(NSString *)title isPresent:(BOOL)isPresent;

@end
