//
//  PWThanksForOrderHolderController.m
//  PocketWaiter
//
//  Created by Www Www on 10/2/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWThanksForOrderHolderController.h"
#import "PWRestaurant.h"
#import "PWPurchase.h"
#import "PWPrice.h"

@interface PWThanksForOrderHolderController ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *collectedBonusesHolder;
@property (strong, nonatomic) IBOutlet UILabel *collectedLabel;
@property (strong, nonatomic) IBOutlet UILabel *bonusesCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bonusImageView;
@property (strong, nonatomic) IBOutlet UILabel *buttonTitle;
@property (strong, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, strong) PWRestaurant *restaurant;
@property (nonatomic, strong) PWPurchase *purchase;
@property (nonatomic, copy) void (^backHandler)();
@property (nonatomic) BOOL firstPresent;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

@end

@implementation PWThanksForOrderHolderController

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant
			purchase:(PWPurchase *)purchase backHandler:(void (^)())handler
			isFirstPresent:(BOOL)firstPresent
{
	self = [super init];
	
	if (nil != self)
	{
		self.restaurant = restaurant;
		self.purchase = purchase;
		self.backHandler = handler;
		self.firstPresent = firstPresent;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setupConstraints];
	self.titleLabel.text = @"Спасибо!";
	self.descriptionLabel.text = self.firstPresent ?
				@"Ваш подарок уже готовиться на кухне" :
				@"Ваш заказ уже готовиться на кухне, а бонусы будут начислены в течении 2х часов после оплаты заказа";
	
	if (self.firstPresent)
	{
		[self.collectedBonusesHolder removeFromSuperview];
	}
	else
	{
		self.collectedLabel.text = @"Бонусов начисленно:";
		self.bonusesCountLabel.text = [NSString stringWithFormat:@"+ %li", (long)self.purchase.totalPrice.value];
		self.collectedLabel.textColor = self.restaurant.color;
		self.bonusesCountLabel.textColor = self.restaurant.color;
		self.bonusImageView.image = [[UIImage imageNamed:@"collectedBonus"]
					imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		self.bonusImageView.tintColor = self.restaurant.color;
	}
	
	self.button.backgroundColor = self.restaurant.color;
	self.buttonTitle.text = @"Вернуться в меню";
}

- (IBAction)backAction:(UIButton *)sender
{
	if (nil != self.backHandler)
	{
		self.backHandler();
	}
}

- (void)setupConstraints
{
	self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.view
				attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
				toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:320];
	self.widthConstraint = [NSLayoutConstraint constraintWithItem:self.view
				attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
				toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:320];
	
	[self.view addConstraint:self.widthConstraint];
	[self.view addConstraint:self.heightConstraint];
}

- (void)setContentSize:(CGSize)contentSize
{
	self.widthConstraint.constant = contentSize.width;
	self.heightConstraint.constant = contentSize.height;
	
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
}

- (CGSize)contentSize
{
	return CGSizeMake(self.widthConstraint.constant,
				self.heightConstraint.constant);
}


@end
