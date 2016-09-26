//
//  PWActiveRootController.h
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWMainMenuItemViewController.h"
@class PWRestaurant;

@interface PWActiveRootController : PWMainMenuItemViewController

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant
			transitionHandler:(PWContentTransitionHandler)aHandler
			forwardTransitionHandler:(PWContentTransitionHandler)aFwdHandler;

@end
