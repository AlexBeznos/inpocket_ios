//
//  PWShareVithFriendsController.m
//  PocketWaiter
//
//  Created by Www Www on 9/4/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWShareWithFriendsController.h"
#import "PWSharePromoController.h"
#import "PWModalController.h"

@interface PWShareWithFriendsController ()

@property (strong, nonatomic) IBOutlet UILabel *inviteTitle;
@property (strong, nonatomic) IBOutlet UILabel *inviteDescription;
@property (strong, nonatomic) IBOutlet UILabel *inviteButtonLabel;
@property (strong, nonatomic) IBOutlet UILabel *shareTitle;
@property (strong, nonatomic) IBOutlet UILabel *shareDescription;
@property (strong, nonatomic) IBOutlet UILabel *shareButtonTitle;

@property (nonatomic, strong) PWModalController *modal;

@end

@implementation PWShareWithFriendsController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.inviteTitle.text = @"Приглашайте друзей и получайте бонусы";
	self.inviteDescription.text = @"Отправте промо-код своему другу и получите 50 бонусов!!!";
	self.inviteButtonLabel.text = @"Пригласить друга";
	self.shareTitle.text = @"Больше бонусов для друзей!";
	self.shareDescription.text = @"Поделитесь со своими друзьями и пусть они тоже получат свой первый подарок";
	self.shareButtonTitle.text = @"Поделиться";
}

- (IBAction)invite:(UIButton *)sender
{
	__weak __typeof(self) weakSelf = self;
	PWSharePromoController *sharePromoController = [[PWSharePromoController alloc]
				initWithPromo:@"sdasgeradfgsds" completion:
	^(BOOL success)
	{
		[weakSelf.modal hideWithCompletion:nil];
	}];
	
	sharePromoController.contentSize = CGSizeMake(280, 350);
	self.modal = [[PWModalController alloc] initWithContentController:
				sharePromoController autoDismiss:NO];
	[self.modal showWithCompletion:nil];
}

- (IBAction)share:(UIButton *)sender
{

}

- (NSString *)name
{
	return @"Поделиться с друзьями";
}

@end
