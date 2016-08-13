//
//  PWMainViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/6/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWMainViewController.h"
#import "PWIntroViewController.h"

#import "PWRootMenuTableViewController.h"
#import "UIViewControllerAdditions.h"
#import "PWQRCodeScanViewController.h"

@interface PWMainViewController ()

@property (nonatomic, strong) PWIntroViewController *introController;
@property (nonatomic, strong) PWRootMenuTableViewController *rootMenuController;

@end

@implementation PWMainViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationController.navigationBarHidden = YES;
	
	#if 1
	__weak __typeof(self) theWeakSelf = self;
	self.introController = [[PWIntroViewController alloc]
				initWithCompletionHandler:
	^{
		#if 0
		theWeakSelf.rootMenuController = [PWRootMenuTableViewController new];
		[theWeakSelf navigateViewController:theWeakSelf.rootMenuController];
		#else
		PWQRCodeScanViewController *controller =
					[[PWQRCodeScanViewController alloc] initWithCompletion:
		^{
			theWeakSelf.rootMenuController = [PWRootMenuTableViewController new];
			[theWeakSelf navigateViewController:theWeakSelf.rootMenuController];
		}];
		[theWeakSelf navigateViewController:controller];
		#endif
	}];
	[self setupChildController:self.introController];
	#else
	self.rootMenuController = [PWRootMenuTableViewController new];
	[self navigateViewController:self.rootMenuController];

	#endif
}

- (void)setupChildController:(UIViewController *)controller
{
	[self addChildViewController:controller];
	[self.view addSubview:controller.view];
	[controller didMoveToParentViewController:self];
	controller.view.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : controller.view}]];
	[self.view addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : controller.view}]];
}

@end
