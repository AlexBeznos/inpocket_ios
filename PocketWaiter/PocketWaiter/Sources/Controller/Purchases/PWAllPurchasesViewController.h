//
//  PWAllPurchasesViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/24/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "UIViewControllerAdditions.h"

@class PWUser;
@class PWRestaurant;

@interface PWAllPurchasesViewController : UIViewController

- (instancetype)initWithUser:(PWUser *)user
			restaurants:(NSArray<PWRestaurant *> *)restaurants
			transiter:(id<IPWTransiter>)transiter;

- (void)setWidth:(CGFloat)contentWidth;

@end
