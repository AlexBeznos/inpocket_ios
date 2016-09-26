//
//  PWFirstPresentDetailsController.h
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewControllerAdditions.h"

@class PWPresentProduct;
@class PWRestaurant;

@interface PWFirstPresentDetailsController : UIViewController <IPWTransitableController>

- (instancetype)initWithPresent:(PWPresentProduct *)present restaurant:(PWRestaurant *)restaurant;

@end
