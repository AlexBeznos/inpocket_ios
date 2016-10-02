//
//  PWThanksForOrderViewController.h
//  PocketWaiter
//
//  Created by Www Www on 10/2/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWScrollableViewController.h"
#import "UIViewControllerAdditions.h"

@class PWRestaurant;
@class PWPurchase;

@interface PWThanksForOrderViewController : PWScrollableViewController
			<IPWTransitableController>

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant
			purchase:(PWPurchase *)purchase title:(NSString *)title
			contentWidth:(CGFloat)width isFirstPresent:(BOOL)firstPresent;

@end
