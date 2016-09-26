//
//  PWWelcomeViewController.h
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWModalController.h"

@class PWRestaurant;

@interface PWWelcomeViewController :
			UIViewController <IPWModalContentController>

- (instancetype)initWithRestaurant:(PWRestaurant *)aRestaurant continueHandler:(void (^)())aHandler;

@end
