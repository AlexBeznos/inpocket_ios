//
//  PWRestaurantPurchasesController.m
//  PocketWaiter
//
//  Created by Www Www on 8/24/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRestaurantPurchasesController.h"
#import "PWModelManager.h"
#import "PWPurchaseTableViewCell.h"
#import "UIColorAdditions.h"
#import "PWActivityIndicator.h"

@interface PWRestaurantPurchasesController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PWUser *user;
@property (nonatomic, strong) PWRestaurant *restaurant;
@property (nonatomic, strong) NSArray<PWPurchase *> *purchases;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) void (^sizeHandler)(CGFloat);

@end

@implementation PWRestaurantPurchasesController

- (instancetype)initWithUser:(PWUser *)user
			estimatedHeightHandler:(void (^)(CGFloat))handler
{
	self = [super init];
	
	if (nil != self)
	{
		self.user = user;
		self.sizeHandler = handler;
	}
	
	return self;
}

- (void)updateWithRestaurant:(PWRestaurant *)restaurant
{
	self.purchases = nil;
	[self.tableView reloadData];
	
	self.restaurant = restaurant;
	
	[self startActivityWithTopOffset:-50];
	
	if (nil != restaurant)
	{
		__weak __typeof(self) weakSelf= self;
		
		[[PWModelManager sharedManager] getPurchasesForUser:self.user
					restaurant:self.restaurant withCount:20 offset:0
					completion:^(NSArray<PWPurchase *> *purchases, NSError *error)
		{
			[weakSelf stopActivity];
			weakSelf.purchases = purchases;
			[weakSelf.tableView reloadData];
			
			if (nil != weakSelf.sizeHandler)
			{
				CGFloat height = 0;
				
				for (PWPurchase *purchase in purchases)
				{
					height += 41 + purchase.orders.count * 80;
				}
				
				weakSelf.sizeHandler(height);
			}
		}];
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.tableView = [[UITableView alloc] initWithFrame:CGRectZero
				style:UITableViewStyleGrouped];
	self.tableView.scrollEnabled = NO;
	self.view = self.tableView;
	self.tableView.showsVerticalScrollIndicator = NO;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	
	[self.tableView registerNib:[UINib nibWithNibName:@"PWPurchaseTableViewCell"
				bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"id"];
	[self.tableView registerClass:[UITableViewHeaderFooterView class]
				forHeaderFooterViewReuseIdentifier:@"reuse"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.purchases.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.purchases[section].orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PWPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id" forIndexPath:indexPath];
    
	PWOrder *order = self.purchases[indexPath.section].orders[indexPath.row];
	
	cell.image = order.product.icon;
	cell.name = order.product.name;
	cell.cost = order.product.price.humanReadableValue;
	cell.bonusesCount = order.product.bonusesValue;
	
	cell.backgroundColor = [UIColor pwBackgroundColor];
	
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	PWPurchase *purchase = self.purchases[section];
	UITableViewHeaderFooterView *headerView = [tableView
				dequeueReusableHeaderFooterViewWithIdentifier:@"reuse"];
	headerView.contentView.backgroundColor = [UIColor clearColor];
	
	UILabel *dateLabel = [UILabel new];
	dateLabel.backgroundColor = [UIColor clearColor];
	dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
	dateLabel.font = [UIFont boldSystemFontOfSize:20];
	dateLabel.textColor = [UIColor blackColor];
	
	NSDateFormatter *formatter = [NSDateFormatter new];
	formatter.dateStyle = NSDateFormatterMediumStyle;
	
	dateLabel.text = [formatter stringFromDate:purchase.date];
	
	[headerView addSubview:dateLabel];
	
	[headerView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|-10-[label]-10-|" options:0 metrics:nil
				views:@{@"label" : dateLabel}]];
	[headerView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|-20-[label]" options:0 metrics:nil
				views:@{@"label" : dateLabel}]];
	
	UILabel *bonusesLabel = [UILabel new];
	bonusesLabel.textColor = self.restaurant.color;
	bonusesLabel.backgroundColor = [UIColor clearColor];
	bonusesLabel.translatesAutoresizingMaskIntoConstraints = NO;
	bonusesLabel.text = [NSString stringWithFormat:@"+%li", (unsigned long)purchase.bonusesCount];
	bonusesLabel.font = [UIFont systemFontOfSize:15];
	
	[headerView addSubview:bonusesLabel];
	
	[headerView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|-10-[label]-10-|" options:0 metrics:nil
				views:@{@"label" : bonusesLabel}]];
	
	UIImageView *imageView = [[UIImageView alloc]
				initWithImage:[UIImage imageNamed:@"collectedBonus"]];
	imageView.backgroundColor = [UIColor clearColor];
	imageView.translatesAutoresizingMaskIntoConstraints = NO;
	
	[headerView addSubview:imageView];
	
	[headerView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|-10-[image]-10-|" options:0 metrics:nil
				views:@{@"image" : imageView}]];
	
	[headerView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:[label]-10-[image]-20-|" options:0 metrics:nil
				views:@{@"label" : bonusesLabel, @"image" : imageView}]];
	
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 1;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

@end
