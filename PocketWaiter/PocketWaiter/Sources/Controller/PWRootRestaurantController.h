//
//  PWActiveRootController.h
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWMainMenuItemViewController.h"
@class PWRestaurant;

@interface PWRootRestaurantController : PWMainMenuItemViewController

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant
			defaultMode:(BOOL)defaultMode
			transitionHandler:(PWContentTransitionHandler)aHandler
			forwardTransitionHandler:(PWContentTransitionHandler)aFwdHandler;

@end
