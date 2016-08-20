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

#import "PWModelManager.h"

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
	
	if (nil == [[NSUserDefaults standardUserDefaults] valueForKey:@"showIntro"])
	{
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showIntro"];
	}
	if (nil == [[NSUserDefaults standardUserDefaults] valueForKey:@"showScan"])
	{
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showScan"];
	}
	if (nil == [[NSUserDefaults standardUserDefaults] valueForKey:@"showDefault"])
	{
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showDefault"];
	}
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showIntro"])
	{
		__weak __typeof(self) theWeakSelf = self;
		self.introController = [[PWIntroViewController alloc]
					initWithCompletionHandler:
		^{
			[theWeakSelf showMainFlow];
			[theWeakSelf.introController.view removeFromSuperview];
		}];
		[self setupChildController:self.introController];
	}
	else
	{
		[self showMainFlow];
	}
}

- (void)showMainFlow
{
	self.blueToothManager = [PWBluetoothManager new];
	[self startActivity];
	__weak __typeof(self) weakSelf = self;
	[self.blueToothManager startScanBeaconsForInterval:3 completion:
	^(NSArray<NSString *> *beacons, NSError *error)
	{
		if (nil == error)
		{
			[[PWModelManager sharedManager] getRestaurantForBeacons:beacons
						completion:^(PWRestaurant *restaurant, NSError *error)
			{
				if (nil == error)
				{
					// show main mode
				}
				else
				{
					[weakSelf showDefaultMode];
				}
				[weakSelf stopActivity];
			}];
		}
		else
		{
			[weakSelf stopActivity];
			[weakSelf showDefaultMode];
			// show error
		}
		NSLog(@"Found uuids: %@\n\nError: %@", [beacons description], error);
	}];
}

- (void)showDefaultMode
{
	if (![[NSUserDefaults standardUserDefaults] boolForKey:@"showScan"])
	{
		self.rootMenuController = [PWRootMenuTableViewController new];
		[self navigateViewController:self.rootMenuController];
	}
	else
	{
		__weak __typeof(self) weakSelf = self;
		PWQRCodeScanViewController *controller =
					[[PWQRCodeScanViewController alloc] initWithCompletion:
		^{
			weakSelf.rootMenuController = [PWRootMenuTableViewController new];
			[weakSelf navigateViewController:weakSelf.rootMenuController];
		}];
		[self navigateViewController:controller];
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
