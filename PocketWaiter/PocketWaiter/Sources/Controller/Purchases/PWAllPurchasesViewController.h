//
//  PWAllPurchasesViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/24/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWUser;
@class PWRestaurant;

@interface PWAllPurchasesViewController : UIViewController

- (instancetype)initWithUser:(PWUser *)user restaurants:(NSArray<PWRestaurant *> *)restaurants;

- (void)setWidth:(CGFloat)contentWidth;

@end
