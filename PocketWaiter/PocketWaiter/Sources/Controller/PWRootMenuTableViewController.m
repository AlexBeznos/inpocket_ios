//
//  PWRootMenuTableViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/6/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRootMenuTableViewController.h"
#import "PWContentSource.h"
#import "PWModelManager.h"
#import "PWRestaurantAboutInfo.h"
#import "PWMainMenuViewController.h"
#import "UIViewControllerAdditions.h"
#import "PWRestaurantsViewController.h"
#import "PWAboutController.h"
#import "PWShareWithFriendsController.h"

@interface PWRootMenuTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readonly) NSArray<PWContentSource *> *sources;
@property (nonatomic, strong) PWRestaurant *restaurant;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSLayoutConstraint *transitionConstrain;
@property (nonatomic, strong) UIViewController *selectedController;
@property (nonatomic, strong) PWContentSource *selectedSource;
@property (nonatomic, strong) UIViewController<IPWContentTransitionControler> *mainController;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PWRootMenuTableViewController

@synthesize sources = _sources;

- (instancetype)initWithMode:(BOOL)defaultMode
{
	self = [super init];
	
	if (nil != self)
	{
		__weak __typeof(self) theWeakSelf = self;
		
		self.mainController = defaultMode ? [[PWMainMenuViewController alloc]
					initWithTransitionHandler:
		^{
			[theWeakSelf performBackTransition];
		}
					forwardTransitionHandler:
		^{
			[theWeakSelf performForwardTransition];
		}] : nil ;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor blackColor];
	self.tableView = [UITableView new];
	self.tableView.backgroundColor = [UIColor blackColor];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView registerClass:[UITableViewCell class]
				forCellReuseIdentifier:@"id"];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	
	self.tableView.scrollEnabled = NO;
	
	[self.view addSubview:self.tableView];
	self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.view addConstraint:[NSLayoutConstraint
				constraintWithItem:self.view attribute:NSLayoutAttributeHeight
				relatedBy:NSLayoutRelationEqual toItem:self.tableView
				attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
	
	[self.view addConstraint:[NSLayoutConstraint
				constraintWithItem:self.view attribute:NSLayoutAttributeWidth
				relatedBy:NSLayoutRelationEqual toItem:self.tableView
				attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
	
	[self.view addConstraint:[NSLayoutConstraint
				constraintWithItem:self.view attribute:NSLayoutAttributeTop
				relatedBy:NSLayoutRelationEqual toItem:self.tableView
				attribute:NSLayoutAttributeTop multiplier:1
				constant:0]];
	
	[self.view addConstraint:[NSLayoutConstraint
				constraintWithItem:self.view attribute:NSLayoutAttributeLeft
				relatedBy:NSLayoutRelationEqual toItem:self.tableView
				attribute:NSLayoutAttributeLeft multiplier:1
				constant:0]];
	
	self.selectedSource = self.sources.firstObject;
	
	UINavigationController *navigation = [[UINavigationController alloc]
				initWithRootViewController:self.mainController];
	navigation.navigationBar.translucent = NO;
	self.selectedController = navigation;
	
	[self addChildViewController:navigation];
	[self.view addSubview:navigation.view];
	navigation.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.view addConstraint:[NSLayoutConstraint
				constraintWithItem:self.view attribute:NSLayoutAttributeHeight
				relatedBy:NSLayoutRelationEqual toItem:navigation.view
				attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
	
	[self.view addConstraint:[NSLayoutConstraint
				constraintWithItem:self.view attribute:NSLayoutAttributeWidth
				relatedBy:NSLayoutRelationEqual toItem:navigation.view
				attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
	
	[self.view addConstraint:[NSLayoutConstraint
				constraintWithItem:self.view attribute:NSLayoutAttributeTop
				relatedBy:NSLayoutRelationEqual toItem:navigation.view
				attribute:NSLayoutAttributeTop multiplier:1
				constant:0]];
	
	self.transitionConstrain = [NSLayoutConstraint
				constraintWithItem:self.view attribute:NSLayoutAttributeLeft
				relatedBy:NSLayoutRelationEqual toItem:navigation.view
				attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
	
	[self.view addConstraint:self.transitionConstrain];
}

- (NSArray<PWContentSource *> *)sources
{
	if (nil == _sources)
	{
		__weak __typeof(self) theWeakSelf = self;
		PWContentSource *mainSource = [[PWContentSource alloc]
					initWithTitle:@"Главная" details:self.restaurant.aboutInfo.name
					icon:[UIImage imageNamed:@"whiteBonus"]
					contentViewController:self.mainController];
		
		PWContentSource *restaurantsSource = [[PWContentSource alloc]
					initWithTitle:@"Заведения" details:nil
					icon:[UIImage imageNamed:@"whiteRestaurants"]
					contentViewController:[[PWRestaurantsViewController alloc]
					initWithTransitionHandler:
		^{
			[theWeakSelf performBackTransition];
		}
					forwardTransitionHandler:
		^{
			[theWeakSelf performForwardTransition];
		}]];
		
		PWContentSource *shareSource = [[PWContentSource alloc]
					initWithTitle:@"Поделиться" details:nil
					icon:[UIImage imageNamed:@"whiteShare"]
					contentViewController:[[PWShareWithFriendsController alloc]
					initWithTransitionHandler:
		^{
			[theWeakSelf performBackTransition];
		}
					forwardTransitionHandler:
		^{
			[theWeakSelf performForwardTransition];
		}]];
		
		PWContentSource *aboutSource = [[PWContentSource alloc]
					initWithTitle:@"О приложении" details:nil
					icon:[UIImage imageNamed:@"whiteAbout"]
					contentViewController:[[PWAboutController alloc]
					initWithTransitionHandler:
		^{
			[theWeakSelf performBackTransition];
		}
					forwardTransitionHandler:
		^{
			[theWeakSelf performForwardTransition];
		}]];
		
		PWContentSource *profileSource = [[PWContentSource alloc]
					initWithTitle:@"Профиль" details:[[PWModelManager sharedManager]
					registeredUser].humanReadableName
					icon:[UIImage imageNamed:@"whiteProfile"]
					contentViewController:[[PWMainMenuViewController alloc]
					initWithTransitionHandler:
		^{
			[theWeakSelf performBackTransition];
		}
					forwardTransitionHandler:
		^{
			[theWeakSelf performForwardTransition];
		}]];
		
		_sources = @[mainSource, restaurantsSource, shareSource,
					aboutSource, profileSource];
	}
	
	return _sources;
}

- (UIView *)headerView
{
	if (nil == _headerView)
	{
		_headerView = [UIView new];
		_headerView.translatesAutoresizingMaskIntoConstraints = NO;
		_headerView.backgroundColor = [UIColor blackColor];
		
		[_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_headerView
					attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
					toItem:nil attribute:NSLayoutAttributeNotAnAttribute
					multiplier:1 constant:120]];
		[_headerView addConstraint:[NSLayoutConstraint constraintWithItem:_headerView
					attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
					toItem:nil attribute:NSLayoutAttributeNotAnAttribute
					multiplier:1 constant:CGRectGetWidth(self.parentViewController.view.frame)]];
		
		UIImageView *imageView = [[UIImageView alloc]
					initWithImage:[UIImage imageNamed:@"piclogowhite"]];
		[imageView sizeToFit];
		imageView.translatesAutoresizingMaskIntoConstraints = NO;
		[imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
					attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
					toItem:nil attribute:NSLayoutAttributeNotAnAttribute
					multiplier:1 constant:CGRectGetWidth(imageView.frame)]];
		
		[imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
					attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
					toItem:nil attribute:NSLayoutAttributeNotAnAttribute
					multiplier:1 constant:CGRectGetHeight(imageView.frame)]];
		
		[_headerView addSubview:imageView];
		
		[_headerView addConstraints:[NSLayoutConstraint
					constraintsWithVisualFormat:@"H:|-20-[imageView]"
					options:0 metrics:nil
					views:@{@"imageView" : imageView}]];
		
		[_headerView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
					attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
					toItem:_headerView attribute:NSLayoutAttributeCenterY
					multiplier:1 constant:0]];
		[_headerView setNeedsLayout];
		[_headerView layoutIfNeeded];
	}
	
	return _headerView;
}

- (void)performBackTransition
{
	self.selectedController.view.userInteractionEnabled = NO;
	[UIView animateWithDuration:0.25 animations:
	^{
		self.transitionConstrain.constant = -300;
		[self.view setNeedsLayout];
		[self.view layoutIfNeeded];
	}
				completion:
	^(BOOL finished)
	{
		self.selectedController.view.userInteractionEnabled = YES;
	}];
}

- (void)performForwardTransition
{
	self.selectedController.view.userInteractionEnabled = NO;
	[UIView animateWithDuration:0.25 animations:
	^{
		self.transitionConstrain.constant = 0;
		[self.view setNeedsLayout];
		[self.view layoutIfNeeded];
	}
				completion:
	^(BOOL finished)
	{
		[self.selectedSource.contentViewController resetTransition];
		self.selectedController.view.userInteractionEnabled = YES;
	}];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView
			numberOfRowsInSection:(NSInteger)section
{
	return self.sources.count;
}

- (CGFloat)tableView:(UITableView *)tableView
			heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (UIView *)tableView:(UITableView *)tableView
			viewForHeaderInSection:(NSInteger)section
{
	return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView
			heightForHeaderInSection:(NSInteger)section
{
	return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
			cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"
				forIndexPath:indexPath];
	
	PWContentSource *currentSource = self.sources[indexPath.row];
	
	cell.textLabel.text = currentSource.title;
	cell.imageView.image = currentSource.icon;
	cell.detailTextLabel.text = currentSource.details;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView
			willDisplayCell:(UITableViewCell *)cell
			forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// add customization
	
	cell.backgroundColor = [UIColor blackColor];
	
	UIView *selectedBackgroundView = [UIView new];
	selectedBackgroundView.backgroundColor = [UIColor grayColor];
	selectedBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
	cell.selectedBackgroundView = selectedBackgroundView;
	
	cell.textLabel.textColor = [UIColor lightGrayColor];
	cell.detailTextLabel.textColor = [UIColor lightGrayColor];
}

- (void)tableView:(UITableView *)tableView
			didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	PWContentSource *currentSource = self.sources[indexPath.row];
	UIViewController *contentController = currentSource.contentViewController;
	
	if (nil != contentController)
	{
		[self.selectedSource.contentViewController resetTransition];
		
		if (currentSource != self.selectedSource)
		{
			[self.selectedController.view removeFromSuperview];
			
			self.selectedSource = currentSource;
			UINavigationController *navigation = [[UINavigationController alloc]
						initWithRootViewController:contentController];
			navigation.navigationBar.translucent = NO;
			// TODO customize navigarion bar
			self.selectedController = navigation;
			self.transitionConstrain = [self navigateViewController:navigation];
		}
		else
		{
			[self performForwardTransition];
		}
	}
}

@end
