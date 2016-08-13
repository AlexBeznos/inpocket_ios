//
//  UIViewControllerAdditions.h
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPWTransitableController;

@protocol IPWTransiter <NSObject>

@property (nonatomic, strong)
			UIViewController<IPWTransitableController> *transitedController;

- (void)performBackTransitionWithSetupNaigationItem:(BOOL)setup;
- (void)performForwardTransition:
			(UIViewController<IPWTransitableController> *)controller;

@end

@protocol IPWTransitableController <NSObject>

@property (nonatomic, weak) id<IPWTransiter> transiter;

- (void)setupWithNavigationItem:(UINavigationItem *)item;

@end

@interface UIViewController (SetupAdditions)

- (void)setupNavigationBar;
- (void)setupMenuItemWithTarget:(id)target action:(SEL)action
			navigationItem:(UINavigationItem *)item;

- (void)setupBackItemWithTarget:(id)target action:(SEL)action
			navigationItem:(UINavigationItem *)item;

- (NSLayoutConstraint *)navigateViewController:(UIViewController *)controller;

@end
