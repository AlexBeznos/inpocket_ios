//
//  PWThanksForOrderHolderController.h
//  PocketWaiter
//
//  Created by Www Www on 10/2/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWRestaurant;
@class PWPurchase;

@interface PWThanksForOrderHolderController : UIViewController

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant
			purchase:(PWPurchase *)purchase backHandler:(void (^)())handler
			isFirstPresent:(BOOL)firstPresent;
@property (nonatomic) CGSize contentSize;

@end
