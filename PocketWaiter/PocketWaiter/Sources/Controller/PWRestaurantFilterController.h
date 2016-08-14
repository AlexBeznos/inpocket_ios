//
//  PWRestaurantFilterController.h
//  PocketWaiter
//
//  Created by Www Www on 8/14/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWEnums.h"
#import "UIViewControllerAdditions.h"

@interface PWRestaurantFilterController : UIViewController
			<IPWTransitableController>

- (instancetype)initWithCurrentFilter:(PWRestaurantType)filter typeHandler:
			(void (^)(PWRestaurantType type))aHandler;

@end
