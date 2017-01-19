//
//  PWThanksForOrderHolderController.m
//  PocketWaiter
//
//  Created by Www Www on 10/2/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWThanksForController.h"
#import "PWRestaurant.h"
#import "PWPurchase.h"
#import "PWPrice.h"

@interface PWThanksForController ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *collectedBonusesHolder;
@property (strong, nonatomic) IBOutlet UILabel *collectedLabel;
@property (strong, nonatomic) IBOutlet UILabel *bonusesCountLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bonusImageView;
@property (strong, nonatomic) IBOutlet UILabel *buttonTitle;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *optionalButtonTopOffset;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonTopOffset;

@property (nonatomic, strong) UIColor *scheme;
@property (nonatomic, copy) void (^backHandler)();
@property (nonatomic) PWItemType type;
@property (nonatomic) NSUInteger bonusesCount;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

@end

@implementation PWThanksForController

- (instancetype)initWithType:(PWItemType)type scheme:(UIColor *)color
			bonusesCount:(NSUInteger)count backHandler:(void (^)())handler
{
	self = [super init];
	
	if (nil != self)
	{
		self.scheme = color;
		self.backHandler = handler;
		self.type = type;
		self.bonusesCount = count;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setupConstraints];
	self.titleLabel.text = self.type == kPWItemTypeComment ? @"Спасибо за ваш отзыв" : @"Спасибо!";
	
	NSString *description = nil;
	NSString *backTitle = nil;
	
	switch (self.type)
	{
		case kPWItemTypeComment:
		{
			description = @"Мы очень благодарны вам за отзыв и дарим в подарок бонусы на ваш счет";
			backTitle = @"Вернуться к отзывам";
		}
		break;
		
		case kPWItemTypePurchase:
		{
			description = @"Ваш заказ уже готовиться на кухне, а бонусы будут начислены в течении 2х часов после оплаты заказа";
			backTitle = @"Вернуться к акциям";
		}
		break;
		
		case kPWItemTypePresent:
		{
			description = @"Ваш подарок уже готовиться на кухне";
			backTitle = @"Вернуться в меню";
		}
		break;
	}
	
	self.descriptionLabel.text = description;
	
	if (self.type == kPWItemTypePresent)
	{
        self.imageView.image = [[UIImage imageNamed:@"collectedBonus"]
                                     imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.imageView.tintColor = self.scheme;
		[self.collectedBonusesHolder removeFromSuperview];
	}
	else
	{
		self.collectedLabel.text = @"Бонусов начисленно:";
		self.bonusesCountLabel.text = [NSString stringWithFormat:@"+ %li", (long)self.bonusesCount];
		self.collectedLabel.textColor = self.scheme;
		self.bonusesCountLabel.textColor = self.scheme;
		self.bonusImageView.image = [[UIImage imageNamed:@"collectedBonus"]
					imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		self.bonusImageView.tintColor = self.scheme;
		
		self.buttonTopOffset.constant = self.type == kPWItemTypePurchase ? 10 : 30;
	}
	
	self.button.backgroundColor = self.scheme;
	self.buttonTitle.text = backTitle;
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
