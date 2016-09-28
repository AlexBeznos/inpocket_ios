//
//  PWnearRestaurantsViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/11/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWNearItemsViewController.h"

@class PWRestaurant;

@interface PWNearRestaurantsViewController : PWNearItemsViewController

- (instancetype)initWithRestaurants:(NSArray<PWRestaurant *> *)restaurants
			scrollHandler:(void (^)(CGPoint velocity))aHandler
			transiter:(id<IPWTransiter>)transiter;

@property (nonatomic, readonly) CGFloat resizableContentSpace;
@property (nonatomic, readonly) CGFloat fixedContentSpace;

@end
