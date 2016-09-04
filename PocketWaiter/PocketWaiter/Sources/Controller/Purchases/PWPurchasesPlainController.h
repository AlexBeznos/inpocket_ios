//
//  PWPurchasesPlainController.h
//  PocketWaiter
//
//  Created by Www Www on 9/4/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "UIViewControllerAdditions.h"

@class PWRestaurant;

@interface PWPurchasesPlainController : UICollectionViewController
			<IPWTransitableController>

- (instancetype)initWithRestaurants:(NSArray<PWRestaurant *> *)restaurants
			restaurantHandler:(void (^)(PWRestaurant *))handler;

- (void)setWidth:(CGFloat)contentWidth;

@end
