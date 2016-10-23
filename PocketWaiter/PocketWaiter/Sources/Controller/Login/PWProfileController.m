//
//  PWProfileController.m
//  PocketWaiter
//
//  Created by Www Www on 10/23/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWProfileController.h"
#import "PWAvatarCell.h"
#import "UIColorAdditions.h"
#import "PWImageView.h"

@interface PWProfileController ()

@property (nonatomic, strong) NSMutableArray *sections;

@end

@implementation PWProfileController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.tableView.backgroundColor = [UIColor pwBackgroundColor];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	self.sections = [NSMutableArray array];
	
	PWUser *user = USER;
	
	[self.tableView registerNib:[UINib nibWithNibName:@"PWAvatarCell"
				bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"avatar"];
	NSDictionary *avatarSection = @{@"title" : @"Фото профиля"};
	
	[self.sections addObject:avatarSection];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.sections.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *view = [UIView new];
	view.backgroundColor = [UIColor clearColor];
	
	UILabel *label = [UILabel new];
	label.backgroundColor = [UIColor clearColor];
	label.translatesAutoresizingMaskIntoConstraints = NO;
	
	label.font = [UIFont systemFontOfSize:20];
	label.textColor = [UIColor grayColor];
	label.text = [self.sections[section] objectForKey:@"title"];
	[label sizeToFit];
	
	[view addSubview:label];
	
	[view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
				@"H:|-10-[view]" options:0 metrics:nil views:@{@"view" : label}]];
	
	[view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
				@"V:[view]-10-|" options:0 metrics:nil views:@{@"view" : label}]];
	
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *createdCell = nil;
	if (0 == indexPath.section)
	{
		PWAvatarCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"avatar"];
		cell.title.text = @"Загрузить новое фото";
		PWUser *user = USER;
		if (nil != user.avatarIcon)
		{
			cell.avatarView.image = user.avatarIcon;
		}
		else
		{
			[cell.avatarView downloadImageFromURL:user.avatarURL completion:
			^(NSURL *localURL)
			{
				UIImage *avatar =  [UIImage imageWithContentsOfFile:localURL.path];
				[user updateWithJsonInfo:@{@"loadedImage" : avatar}];
				[[PWModelManager sharedManager] updateUserWithCompletion:
				^(NSError *error)
				{
					NSLog(@"Avatar updated");
				}];
			}];
		}
		createdCell = cell;
	}
	
	return createdCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger height = 40;
	if (0 == indexPath.section)
	{
		height = 80;
	}
	
	return height;
}

@end
