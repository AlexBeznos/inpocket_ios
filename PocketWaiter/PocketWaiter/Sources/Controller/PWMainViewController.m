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
#import "PWNoConnectionAlertController.h"
#import "PWWelcomeViewController.h"

#import "PWModelManager.h"

@interface PWMainViewController ()

@property (nonatomic, strong) PWIntroViewController *introController;
@property (nonatomic, strong) PWRootMenuTableViewController *rootMenuController;

@property (nonatomic, strong) PWBluetoothManager *blueToothManager;
@property (nonatomic, strong) PWModalController *bluetoothDialog;
@property (nonatomic, strong) PWModalController *internetDialog;
@property (nonatomic, strong) PWModalController *welcomeDialog;

@property (nonatomic, strong) NSArray<NSString *> *beacons;

@end

@implementation PWMainViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.navigationController.navigationBarHidden = YES;
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showIntro"];
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showIntro"])
	{
		__weak __typeof(self) theWeakSelf = self;
		self.introController = [[PWIntroViewController alloc]
					initWithCompletionHandler:
		^{
			[theWeakSelf showMainFlow];
			[theWeakSelf.introController.view removeFromSuperview];
		}];
		[self setupChildController:self.introController inView:self.view];
	}
	else
	{
		[self showMainFlow];
	}
}

- (void)showMainFlow
{
	[self startActivity];
	
	if (nil == [[PWModelManager sharedManager] authToken])
	{
		__weak __typeof(self) weakSelf = self;
		[[PWModelManager sharedManager] autentificateWithCompletion:
		^(NSString *token, NSError *error)
		{
			if (nil == error)
			{
				[[NSUserDefaults standardUserDefaults] setObject:token
							forKey:kPWTokenKey];
				[weakSelf startSearchBeacons];
			}
			else
			{
				[weakSelf showNoInternetDialog];
			}
		}];
	}
	else
	{
		[self startSearchBeacons];
	}
}

- (void)startSearchBeacons
{
	self.blueToothManager = [PWBluetoothManager new];
	__weak __typeof(self) weakSelf = self;
	[self.blueToothManager startScanBeaconsForInterval:1.5 completion:
	^(NSArray<NSString *> *beacons, NSError *error)
	{
		if (nil == error)
		{
			weakSelf.beacons = beacons;
			[weakSelf validateBeacons];
		}
		else
		{
			PWNoConnectionAlertController *alert = [[PWNoConnectionAlertController alloc]
						initWithType:kPWConnectionTypeBluetooth retryAction:
			^{
				[weakSelf.bluetoothDialog hideWithCompletion:
				^{
					[weakSelf showMainFlow];
				}];
			}];
			weakSelf.bluetoothDialog = [[PWModalController alloc]
						initWithContentController:alert autoDismiss:NO];
			[weakSelf.bluetoothDialog showWithCompletion:nil];
			[weakSelf stopActivity];
		}
		NSLog(@"Found uuids: %@\n\nError: %@", [beacons description], error);
	}];
}

- (void)validateBeacons
{
	__weak __typeof(self) weakSelf = self;
	[self startActivity];
	[[PWModelManager sharedManager] getRestaurantForBeacons:self.beacons
				completion:^(PWRestaurant *restaurant, NSError *error)
	{
		if (nil != error)
		{
			[weakSelf showNoInternetDialog];
		}
		else if (nil == restaurant)
		{
			[weakSelf presentRootControllerWithRestaurant:nil];
		}
		else
		{
			PWWelcomeViewController *welcomeController =
			[[PWWelcomeViewController alloc] initWithRestaurant:restaurant
						continueHandler:
			^{
				[weakSelf.welcomeDialog hideWithCompletion:
				^{
					[weakSelf presentRootControllerWithRestaurant:restaurant];
				}];
			}];
			weakSelf.welcomeDialog = [[PWModalController alloc]
						initWithContentController:welcomeController autoDismiss:NO];
			[weakSelf.welcomeDialog showWithCompletion:nil];
		}
		[weakSelf stopActivity];
	}];
}

- (void)presentRootControllerWithRestaurant:(PWRestaurant *)restaurant
{
	self.rootMenuController = [[PWRootMenuTableViewController alloc]
				initWithRestaurant:restaurant];
	[self navigateViewController:self.rootMenuController];
}

- (void)resumeActivity
{
	[self validateBeacons];
}

- (void)suspendActivity
{

}

@end
