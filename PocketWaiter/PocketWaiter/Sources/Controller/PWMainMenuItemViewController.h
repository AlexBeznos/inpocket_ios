//
//  PWMainMenuItemViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/14/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWContentSource.h"

@interface PWMainMenuItemViewController :
			UIViewController <IPWContentTransitionControler>

@property (nonatomic, readonly) NSString *name;

- (void)setupNavigation;

@end
