//
//  PWWelcomeViewController.m
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWWelcomeViewController.h"
#import "PWButton.h"
#import "PWRestaurant.h"

@interface PWWelcomeViewController ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *makeOrderLabel;
@property (strong, nonatomic) IBOutlet UILabel *getPresentLabel;
@property (strong, nonatomic) IBOutlet UILabel *getPercentLabel;
@property (strong, nonatomic) IBOutlet UILabel *shareWithFriendsLabel;
@property (strong, nonatomic) IBOutlet PWButton *continueButton;
@property (nonatomic, strong) PWRestaurant *restaurant;
@property (nonatomic, copy) void (^continueHandler)();

@end

@implementation PWWelcomeViewController

@synthesize contentSize;

- (instancetype)initWithRestaurant:(PWRestaurant *)aRestaurant continueHandler:(void (^)())aHandler
{
	self = [super init];
	
	if (nil != self)
	{
		self.restaurant = aRestaurant;
		self.continueHandler = aHandler;
		self.contentSize = CGSizeMake(300, 380);
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.titleLabel.text = [NSString stringWithFormat:@"Добро пожаловать в %@!", self.restaurant.restaurantName];
	self.titleLabel.textColor = self.restaurant.color;
	self.makeOrderLabel.text = @"Делайте заказ прямо из приложения";
	self.getPercentLabel.text = @"Накапливайте % от чека";
	self.getPresentLabel.text = [NSString stringWithFormat:@"Получайте подарки от %@", self.restaurant.restaurantName];
	self.shareWithFriendsLabel.text = @"Пользуйтесь вместе с друзьями";
	self.continueButton.title = @"Продолжить";
	self.continueButton.colorScheme = [UIColor whiteColor];
	self.continueButton.bgColor = self.restaurant.color;
}

- (IBAction)doContinue:(id)sender
{
	if (nil != self.continueHandler)
	{
		self.continueHandler();
	}
}

@end
