//
//  UIViewControllerAdditions.m
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "UIViewControllerAdditions.h"

@implementation UIViewController (SetupAdditions)

- (void)setupNavigationBar
{
	self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
}

- (void)setupMenuItemWithTarget:(id)target action:(SEL)action
{
	UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
	[menuButton addTarget:target action:action
				forControlEvents:UIControlEventTouchUpInside];
	[menuButton sizeToFit];
	
	self.navigationItem.leftBarButtonItem =
				[[UIBarButtonItem alloc] initWithCustomView:menuButton];
}

- (void)setupBackItem
{
	UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[menuButton setImage:[UIImage imageNamed:@"navigationBack"]
				forState:UIControlStateNormal];
	[menuButton addTarget:self action:@selector(back)
				forControlEvents:UIControlEventTouchUpInside];
	[menuButton sizeToFit];
	
	self.navigationItem.leftBarButtonItem =
				[[UIBarButtonItem alloc] initWithCustomView:menuButton];
}

- (NSLayoutConstraint *)navigateViewController:(UIViewController *)controller
{
	[self addChildViewController:controller];
	[self.view addSubview:controller.view];
	controller.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.view addConstraint:[NSLayoutConstraint
				constraintWithItem:self.view attribute:NSLayoutAttributeHeight
				relatedBy:NSLayoutRelationEqual toItem:controller.view
				attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
	
	[self.view addConstraint:[NSLayoutConstraint
				constraintWithItem:self.view attribute:NSLayoutAttributeWidth
				relatedBy:NSLayoutRelationEqual toItem:controller.view
				attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
	
	NSLayoutConstraint *constraint = [NSLayoutConstraint
				constraintWithItem:self.view attribute:NSLayoutAttributeLeft
				relatedBy:NSLayoutRelationEqual toItem:controller.view
				attribute:NSLayoutAttributeLeft multiplier:1
				constant:-CGRectGetWidth(self.view.frame)];
	
	[self.view addConstraint:constraint];
	
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
	
	[UIView animateWithDuration:0.25 animations:
	^{
		constraint.constant = 0;
		[self.view setNeedsLayout];
		[self.view layoutIfNeeded];
	}];
	
	return constraint;
}

- (void)back
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end