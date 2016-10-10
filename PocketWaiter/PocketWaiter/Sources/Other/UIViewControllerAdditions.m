//
//  UIViewControllerAdditions.m
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "UIViewControllerAdditions.h"
#import "UIColorAdditions.h"

@implementation UIViewController (SetupAdditions)

- (void)setupNavigationBar
{
	[self.navigationController.navigationBar
				setBackgroundImage:[[UIImage imageNamed:@"bgPattern"]
				resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)]
				forBarMetrics:UIBarMetricsDefault];
	self.navigationController.navigationBar.shadowImage = [UIImage new];
	self.navigationController.navigationBar.translucent = NO;
}

- (void)setupMenuItemWithTarget:(id)target action:(SEL)action
			navigationItem:(UINavigationItem *)item
{
	UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
	[menuButton addTarget:target action:action
				forControlEvents:UIControlEventTouchUpInside];
	[menuButton sizeToFit];
	
	item.leftBarButtonItem =
				[[UIBarButtonItem alloc] initWithCustomView:menuButton];
}

- (void)setupBackItemWithTarget:(id)target action:(SEL)action
			navigationItem:(UINavigationItem *)item
{
	UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[menuButton setImage:[UIImage imageNamed:@"navigationBack"]
				forState:UIControlStateNormal];
	[menuButton addTarget:target action:action
				forControlEvents:UIControlEventTouchUpInside];
	[menuButton sizeToFit];
	
	item.leftBarButtonItem =
				[[UIBarButtonItem alloc] initWithCustomView:menuButton];
}

- (void)setupChildController:(UIViewController *)controller inView:(UIView *)view
{
	[self addChildViewController:controller];
	[view addSubview:controller.view];
	[controller didMoveToParentViewController:self];
	controller.view.translatesAutoresizingMaskIntoConstraints = NO;
	[view addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : controller.view}]];
	[view addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : controller.view}]];
}

- (NSLayoutConstraint *)navigateViewController:(UIViewController *)controller
{
	return [self navigateViewController:controller inView:self.view
				withOffsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (NSLayoutConstraint *)navigateViewController:(UIViewController *)controller inView:(UIView *)view withOffsets:(UIEdgeInsets)offsets
{
	[UIApplication sharedApplication].delegate.window.userInteractionEnabled = NO;
	[self addChildViewController:controller];
	[view addSubview:controller.view];
	[controller willMoveToParentViewController:self];
	controller.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.view addConstraint:[NSLayoutConstraint
				constraintWithItem:self.view attribute:NSLayoutAttributeWidth
				relatedBy:NSLayoutRelationEqual toItem:controller.view
				attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
	[view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
				@"V:|-(t)-[view]-(b)-|" options:0 metrics:@{@"t" : @(offsets.top), @"b" : @(offsets.bottom)}
				views:@{@"view" : controller.view}]];
	
	NSLayoutConstraint *constraint = [NSLayoutConstraint
				constraintWithItem:view attribute:NSLayoutAttributeLeft
				relatedBy:NSLayoutRelationEqual toItem:controller.view
				attribute:NSLayoutAttributeLeft multiplier:1
				constant:-CGRectGetWidth(view.frame)];
	
	[view addConstraint:constraint];
	
	[view setNeedsLayout];
	[view layoutIfNeeded];
	
	[UIView animateWithDuration:0.25 animations:
	^{
		constraint.constant = offsets.left;
		[view setNeedsLayout];
		[view layoutIfNeeded];
	} completion:^(BOOL finished)
	{
		[UIApplication sharedApplication].delegate.window.userInteractionEnabled = YES;
	}];
	
	return constraint;
}

@end
