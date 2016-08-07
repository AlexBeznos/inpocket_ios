//
//  PWRootMenuTableViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/6/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRootMenuTableViewController.h"
#import "PWContentSource.h"
#import "PWUser.h"
#import "PWRestaurant.h"
#import "PWRestaurantAboutInfo.h"

@interface PWRootMenuTableViewController ()

@property (nonatomic, readonly) NSArray<PWContentSource *> *sources;
@property (nonatomic, strong) PWUser *user;
@property (nonatomic, strong) PWRestaurant *restaurant;
@property (nonatomic, strong) UIView *headerView;

@end

@implementation PWRootMenuTableViewController

@synthesize sources = _sources;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	 self.view.backgroundColor = [UIColor blackColor];
	 self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	 [self.tableView registerClass:[UITableViewCell class]
				forCellReuseIdentifier:@"id"];
	
	self.tableView.scrollEnabled = NO;
}

- (NSArray<PWContentSource *> *)sources
{
	if (nil == _sources)
	{
		PWContentSource *mainSource = [[PWContentSource alloc]
					initWithTitle:@"Главная" details:self.restaurant.aboutInfo.name
					icon:[UIImage imageNamed:@"whiteBonus"]
					contentViewController:nil];
		
		PWContentSource *restaurantsSource = [[PWContentSource alloc]
					initWithTitle:@"Заведения" details:nil
					icon:[UIImage imageNamed:@"whiteRestaurants"]
					contentViewController:nil];
		
		PWContentSource *shareSource = [[PWContentSource alloc]
					initWithTitle:@"Поделиться" details:nil
					icon:[UIImage imageNamed:@"whiteShare"]
					contentViewController:nil];
		
		PWContentSource *aboutSource = [[PWContentSource alloc]
					initWithTitle:@"О приложении" details:nil
					icon:[UIImage imageNamed:@"whiteAbout"]
					contentViewController:nil];
		
		PWContentSource *profileSource = [[PWContentSource alloc]
					initWithTitle:@"Профиль" details:self.user.userName
					icon:[UIImage imageNamed:@"whiteProfile"]
					contentViewController:nil];
		
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
		[self.navigationController pushViewController:contentController
					animated:YES];
	}
}

@end
