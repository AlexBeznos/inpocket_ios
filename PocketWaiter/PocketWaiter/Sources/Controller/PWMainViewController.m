//
//  PWMainViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/6/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWMainViewController.h"
#import "PWIntroViewController.h"

@interface PWMainViewController ()

@end

@implementation PWMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	 self.navigationController.navigationBarHidden = YES;
	
	 PWIntroViewController *introController = [PWIntroViewController new];
	 [self addChildViewController:introController];
	 [self.view addSubview:introController.view];
	 [introController didMoveToParentViewController:self];
	 introController.view.translatesAutoresizingMaskIntoConstraints = NO;
	 [self.view addConstraints:[NSLayoutConstraint
					constraintsWithVisualFormat:@"V:|[view]|"
					options:0 metrics:nil
					views:@{@"view" : introController.view}]];
	[self.view addConstraints:[NSLayoutConstraint
					constraintsWithVisualFormat:@"H:|[view]|"
					options:0 metrics:nil
					views:@{@"view" : introController.view}]];
}

@end
