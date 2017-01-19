//
//  PWFirstPresentDetailsController.m
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWFirstPresentDetailsController.h"
#import "PWPresentProduct.h"
#import "PWRestaurant.h"
#import "PWButton.h"
#import "UIColorAdditions.h"
#import "PWThanksForOrderViewController.h"
#import "PWPurchase.h"

@interface PWFirstPresentDetailsController ()

@property (nonatomic, strong) PWPresentProduct *present;
@property (nonatomic, strong) PWRestaurant *restaurant;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *bonusView;
@property (strong, nonatomic) IBOutlet UILabel *getPresentView;
@property (strong, nonatomic) IBOutlet PWButton *button;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation PWFirstPresentDetailsController

@synthesize transiter;

- (instancetype)initWithPresent:(PWPresentProduct *)present restaurant:(PWRestaurant *)restaurant
{
	self = [super init];
	
	if (nil != self)
	{
		self.present = present;
		self.restaurant = restaurant;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	self.imageView.image = self.present.icon;
	self.getPresentView.text = @"Ваш первый подарок";
	self.bonusView.image = [[UIImage imageNamed:@"collectedBonus"]
				imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[self.bonusView setTintColor:self.restaurant.color];
	self.nameLabel.text = self.present.name;
	self.button.title = @"Получить подарок";
	self.button.bgColor = self.restaurant.color;
	self.button.colorScheme = [UIColor whiteColor];
    [self.button changeImageWithImage:@"collectedBonus"];
	self.descriptionLabel.text = self.present.productDescription;
}

- (void)setupWithNavigationItem:(UINavigationItem *)item
{
	[self setupBackItemWithTarget:self action:@selector(transitionBack)
				navigationItem:item];
	
	UILabel *theTitleLabel = [UILabel new];
	theTitleLabel.text = @"Первый подарок";
	theTitleLabel.font = [UIFont systemFontOfSize:20];
	[theTitleLabel sizeToFit];
	
	item.leftBarButtonItems = @[item.leftBarButtonItem,
				[[UIBarButtonItem alloc] initWithCustomView:theTitleLabel]];
	item.rightBarButtonItems = nil;
}

- (void)transitionBack
{
	[self.transiter performBackTransition];
}

- (IBAction)getPresent:(PWButton *)sender
{
	CGFloat aspectRatio = CGRectGetWidth(self.parentViewController.view.frame) / 320.;
	PWPurchase *purchase = [[PWPurchase alloc] initWithFirstPresent:self.present];
	PWThanksForOrderViewController *controller = [[PWThanksForOrderViewController alloc]
				initWithRestaurant:self.restaurant purchase:purchase
				title:@"Ваш первый подарок" contentWidth:aspectRatio * 320 isFirstPresent:YES];
	
	[self.transiter performForwardTransition:controller];
}

@end
