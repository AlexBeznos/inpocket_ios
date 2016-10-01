//
//  PWMainMenuItemViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/14/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWContentSource.h"
#import "UIViewControllerAdditions.h"
#import "PWScrollableViewController.h"

@interface PWMainMenuItemViewController : PWScrollableViewController
			<IPWContentTransitionControler, IPWTransiter>

@property (nonatomic, readonly) NSString *name;

- (void)setupNavigation;

@end
