//
//  PWAddToOrderControler.h
//  PocketWaiter
//
//  Created by Www Www on 10/3/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewControllerAdditions.h"

@class PWProduct;
@class PWRestaurant;

@interface PWAddToOrderControler : UIViewController <IPWTransitableController>

- (instancetype)initWithTitle:(NSString *)name product:(PWProduct *)product restaurant:(PWRestaurant *)restaurant;

@end
