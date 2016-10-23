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
#import "PWProfileDoubleInfoCell.h"
#import "PWFacebookManager.h"
#import "PWVKManager.h"

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
	[self.tableView registerNib:[UINib nibWithNibName:@"PWProfileDoubleInfoCell"
				bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"personal"];
	
	NSDictionary *avatarSection = @{@"title" : @"Фото профиля", @"height" : @(80)};
	[self.sections addObject:avatarSection];
	if (nil != user.userName)
	{
		NSDictionary *personalSection = @{@"title" : @"Персональные данные", @"height" : @(130)};
		[self.sections addObject:personalSection];
	}
	NSDictionary *socialSection = @{@"title" : @"Соц. сети", @"height" : @(130)};
	
	[self.sections addObject:socialSection];
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
				@"H:|-20-[view]" options:0 metrics:nil views:@{@"view" : label}]];
	
	[view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
				@"V:[view]-10-|" options:0 metrics:nil views:@{@"view" : label}]];
	
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 40;
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
	else if (1 == indexPath.section)
	{
		PWProfileDoubleInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"personal"];
		NSArray *names = [USER.userName componentsSeparatedByString:@" "];
		cell.firstTitle.text = @"Имя";
		cell.firstDetails.text = names.firstObject;
		cell.secondTitle.text = @"Фамилия";
		cell.secondDetails.text = names.lastObject;
		createdCell = cell;
	}
	else if (2 == indexPath.section)
	{
		PWProfileDoubleInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"personal"];
		PWUser *user = USER;
		cell.firstTitle.text = @"Vkontakte";
		if (nil != user.vkProfile.userName)
		{
			cell.firstDetails.text = user.vkProfile.userName;
		}
		else
		{
			cell.firstDetails.text = @"Войти";
			[cell.firstButton addTarget:self action:@selector(loginVK)
						forControlEvents:UIControlEventTouchUpInside];
		}
		cell.secondTitle.text = @"Facebook";
		if (nil != user.fbProfile.userName)
		{
			cell.secondDetails.text = user.fbProfile.userName;
		}
		else
		{
			cell.secondDetails.text = @"Войти";
			[cell.secondButton addTarget:self action:@selector(loginFB)
						forControlEvents:UIControlEventTouchUpInside];
		}
		createdCell = cell;
	}
	
	return createdCell;
}

- (void)loginVK
{
	__weak __typeof(self) weakSelf = self;
	[[PWVKManager sharedManager] getProfileInfoWithCompletion:
	^(NSDictionary *info, NSError *error)
	{
		if (nil != error)
		{

		}
		else
		{
			PWUser *user = USER;
			[user updateWithJsonInfo:@{@"vk_profile" : info}];
			if (nil == user.avatarIcon)
			{
				user.avatarURL = [NSURL URLWithString:info[@"remote_photo_url"]];
			}
			[[PWModelManager sharedManager] signUpWithProvider:@"vk"
						profile:user.vkProfile completion:
			^(NSError *error)
			{
				if (nil != error)
				{
					user.vkProfile = nil;
				}
				else
				{
					[weakSelf.tableView reloadData];
				}
			}];
		}
	}];

}

- (void)loginFB
{
	__weak __typeof(self) weakSelf = self;
	[[PWFacebookManager sharedManager] getProfileInfoWithCompletion:
	^(NSDictionary *info, NSError *error)
	{
		if (nil != error)
		{
//			[weakSelf showNoInternetDialog];
		}
		else
		{
			PWUser *user = USER;
			[user updateWithJsonInfo:@{@"facebook_profile" : info}];
			if (nil == user.avatarIcon)
			{
				user.avatarURL = [NSURL URLWithString:info[@"remote_photo_url"]];
			}
			[[PWModelManager sharedManager] signUpWithProvider:@"facebook"
						profile:user.fbProfile completion:
			^(NSError *error)
			{
				if (nil != error)
				{
					user.fbProfile = nil;
				}
				else
				{
					[weakSelf.tableView reloadData];
				}
			}];
		}
	}];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self.sections[indexPath.section] objectForKey:@"height"] integerValue];
}

@end
