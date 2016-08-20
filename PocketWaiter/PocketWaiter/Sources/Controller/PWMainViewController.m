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
#import "PWBluetoothManager.h"
#import "UIColorAdditions.h"

@interface PWMainViewController ()

@property (nonatomic, strong) PWIntroViewController *introController;
@property (nonatomic, strong) PWRootMenuTableViewController *rootMenuController;

@property (nonatomic, strong) PWBluetoothManager *blueToothManager;

@end

@implementation PWMainViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationController.navigationBarHidden = YES;
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	
	self.blueToothManager = [PWBluetoothManager new];
	[self.blueToothManager startScanBeaconsForInterval:3 completion:
	^(NSArray<NSString *> *beacons, NSError *error)
	{
		NSLog(@"Found uuids: %@\n\nError: %@", [beacons description], error);
	}];
	
	if (nil == [[NSUserDefaults standardUserDefaults] valueForKey:@"showIntro"])
	{
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showIntro"];
	}
	if (nil == [[NSUserDefaults standardUserDefaults] valueForKey:@"showScan"])
	{
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showScan"];
	}
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showIntro"])
	{
		__weak __typeof(self) theWeakSelf = self;
		self.introController = [[PWIntroViewController alloc]
					initWithCompletionHandler:
		^{
			if (![[NSUserDefaults standardUserDefaults] boolForKey:@"showScan"])
			{
				theWeakSelf.rootMenuController = [PWRootMenuTableViewController new];
				[theWeakSelf navigateViewController:theWeakSelf.rootMenuController];
			}
			else
			{
				PWQRCodeScanViewController *controller =
							[[PWQRCodeScanViewController alloc] initWithCompletion:
				^{
					theWeakSelf.rootMenuController = [PWRootMenuTableViewController new];
					[theWeakSelf navigateViewController:theWeakSelf.rootMenuController];
				}];
				[theWeakSelf navigateViewController:controller];
			}
		}];
		[self setupChildController:self.introController];
	}
	else
	{
		self.rootMenuController = [PWRootMenuTableViewController new];
		[self navigateViewController:self.rootMenuController];
	}
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
