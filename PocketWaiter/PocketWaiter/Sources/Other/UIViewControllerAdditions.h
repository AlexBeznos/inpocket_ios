//
//  UIViewControllerAdditions.h
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SetupAdditions)

- (void)setupNavigationBar;
- (void)setupMenuItemWithTarget:(id)target action:(SEL)action;

- (void)setupBackItem;

- (NSLayoutConstraint *)navigateViewController:(UIViewController *)controller;

@end
