//
//  PWDetailesItemsViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWDetailesItemsViewController.h"
#import "PWTapper.h"

#import "PWDetailedNearItemsCollectionController.h"
#import "PWMapController.h"
#import "UIColorAdditions.h"

@interface PWDetailesItemsViewController ()

@property (strong, nonatomic) IBOutlet PWTapper *tapper;
@property (strong, nonatomic) IBOutlet UIView *contentHolder;

@property (strong, nonatomic)
			PWDetailedNearItemsCollectionController *listController;
@property (strong, nonatomic) PWMapController *mapController;

@property (nonatomic, strong) UIViewController *currentController;

@end

@implementation PWDetailesItemsViewController

@synthesize transiter;

- (NSString *)nibName
{
	return @"PWDetailesItemsViewController";
}

- (void)transitionBack
{
	[self.transiter performBackTransition];
}

- (void)setupWithNavigationItem:(UINavigationItem *)item
{
	[self setupBackItemWithTarget:self action:@selector(transitionBack)
				navigationItem:item];
	
	UILabel *theTitleLabel = [UILabel new];
	theTitleLabel.text = self.navigationTitle;
	theTitleLabel.font = [UIFont systemFontOfSize:20];
	[theTitleLabel sizeToFit];
	
	item.leftBarButtonItems = @[item.leftBarButtonItem,
				[[UIBarButtonItem alloc] initWithCustomView:theTitleLabel]];
	item.rightBarButtonItem = nil;
}

- (NSString *)navigationTitle
{
	return nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	__weak __typeof(self) weakSelf = self;
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	self.contentHolder.backgroundColor = [UIColor pwBackgroundColor];
	
	self.tapper.firstValue = @"СПИСОК";
	self.tapper.secondValue = @"КАРТА";
	self.tapper.tapHandler =
	^(NSUInteger index)
	{
		[weakSelf setupContentWithMode:index];
	};
	
	[self startActivity];
	[self retrieveModelAndSetupInitialControllerWithCompletion:
	^{
		[weakSelf stopActivity];
	}];
}

- (void)retrieveModelAndSetupInitialControllerWithCompletion:
			(void (^)())aCompletion
{
	// no-op
}

- (void)setupContentWithMode:(NSUInteger)mode
{
	[self.currentController.view removeFromSuperview];
	[self.currentController removeFromParentViewController];
	
	if (0 == mode)
	{
		self.listController = [self createListController];
		self.currentController = self.listController;
	}
	else
	{
		self.mapController = [self createMapController];
		self.currentController = self.mapController;
	}
	
	[self addChildViewController:self.currentController];
	[self.contentHolder addSubview:self.currentController.view];
	[self.currentController didMoveToParentViewController:self];
	self.currentController.view.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentHolder addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : self.currentController.view}]];
	[self.contentHolder addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : self.currentController.view}]];
	
	CGFloat aspectRatio = CGRectGetWidth(self.parentViewController.
					view.frame) / 320.;
	if (0 == mode)
	{
		[self.listController setContentSize:CGSizeMake(320 * aspectRatio, 90)];
	}
	else
	{
		[self.mapController setContentSize:CGSizeMake(320 * aspectRatio,
					95 * aspectRatio)];
	}
}

- (PWDetailedNearItemsCollectionController *)createListController
{
	return nil;
}

- (PWMapController *)createMapController
{
	return nil;
}

@end
