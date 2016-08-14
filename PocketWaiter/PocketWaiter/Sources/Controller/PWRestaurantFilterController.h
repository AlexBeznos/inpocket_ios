//
//  PWRestaurantFilterController.h
//  PocketWaiter
//
//  Created by Www Www on 8/14/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWEnums.h"

@interface PWRestaurantFilterController : UIViewController

- (instancetype)initWithFilteredTypeHandler:
			(void (^)(PWRestaurantType type))aHandler
			cancelHandler:(void (^)())aCancelHandler;

@end
