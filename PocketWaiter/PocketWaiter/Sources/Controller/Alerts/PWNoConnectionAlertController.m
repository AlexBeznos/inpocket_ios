//
//  PWNoInternetAlertController.m
//  PocketWaiter
//
//  Created by Www Www on 8/21/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWNoConnectionAlertController.h"

@interface PWNoConnectionAlertController ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailsLabel;
@property (strong, nonatomic) IBOutlet UIButton *retryButton;
@property (nonatomic, copy) void (^retryAction)();
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) PWConnectionType type;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;

@end

@implementation PWNoConnectionAlertController

@synthesize contentSize;

- (instancetype)initWithType:(PWConnectionType)type retryAction:(void (^)())action
{
	self = [super init];
	
	if (nil != self)
	{
		self.retryAction = action;
		self.type = type;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	switch (self.type)
	{
		case kPWConnectionTypeBluetooth:
		{
			self.titleLabel.text = @"Bluetooth...";
			self.detailsLabel.text = @"Для того, чтобы можно было вас зачекинить в заведении, включите блютуз	для работы приложения";
			self.imageView.image = [UIImage imageNamed:@"collectedBonus"];
			self.contentSize = CGSizeMake(300, 240);
		}
		break;
		
		case kPWConnectionTypeInternet:
		{
			self.titleLabel.text = @"Упс...";
			self.detailsLabel.text = @"Мы не можем присоединиться к сети. Зайдите в настройки  Wi Fi и попробуйте соединитьсяили войдите позже";
			self.imageView.image = [UIImage imageNamed:@"loading"];
			self.contentSize = CGSizeMake(300, 240);
		}
		break;
		
		case kPWConnectionTypeLocation:
		{
			self.titleLabel.text = @"Геолокация";
			self.detailsLabel.text = @"Для того чтобы лучше вам предлагать акци рядом, нам нужно разрешение на геолокациюю Включите геолокацию и повторите попытку";
			self.imageView.image = [UIImage imageNamed:@"location"];
			self.contentSize = CGSizeMake(300, 240);
		}
		break;
	}
	
	[self.retryButton setTitle:@"Попробовать снова" forState:UIControlStateNormal];
	[self.settingsButton setTitle:@"Настроить" forState:UIControlStateNormal];
}

- (IBAction)retryAction:(id)sender
{
	if (nil != self.retryAction)
	{
		self.retryAction();
	}
}

- (IBAction)settingsAction:(id)sender
{
	[[UIApplication sharedApplication]
				openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

@end
