//
//  PWIntroFirstPageCell.m
//  PocketWaiter
//
//  Created by Www Www on 8/6/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWIntroFirstPageCell.h"

@interface PWIntroFirstPageCell ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@end

@interface PWIntroSecondPageCell ()

@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topOffset;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftOffset;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightOffset;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomOffset;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@interface PWIntroThirdPageCell ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightConstrailt;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewOffset;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIButton *promoButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topPromoButtonConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topInfoLabelConstraint;

@end

@implementation PWIntroFirstPageCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.infoLabel.text = @"Получайте подарки в нашем любимом заведении";
	
	self.aspectRatio = 1;
}

- (void)setAspectRatio:(CGFloat)aspectRatio
{
	self.topConstraint.constant = 35 * aspectRatio;
	self.leftConstraint.constant = 0 * aspectRatio;
	self.rightConstraint.constant = 0 * aspectRatio;
	self.bottomConstraint.constant = 18 * aspectRatio;
	self.heightConstraint.constant = 267 * aspectRatio;
}

@end

@implementation PWIntroSecondPageCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.infoLabel.text = @"Заказывайте блюда из меню через приложение";
	
	self.aspectRatio = 1;
}

- (void)setAspectRatio:(CGFloat)aspectRatio
{
	self.topOffset.constant = 62 * aspectRatio;
	self.leftOffset.constant = 40 * aspectRatio;
	self.rightOffset.constant = 7 * aspectRatio;
	self.bottomOffset.constant = 0 * aspectRatio;
	self.heightConstraint.constant = 258 * aspectRatio;
}

@end

@implementation PWIntroThirdPageCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.infoLabel.text = @"Cкачали приложение по рекомендации друга?";
	[self.promoButton setTitle:@"Ввести промо код" forState:UIControlStateNormal];
	self.aspectRatio = 1;
}

- (void)setAspectRatio:(CGFloat)aspectRatio
{
	self.topConstraint.constant = 36 * aspectRatio;
	self.leftConstraint.constant = 0 * aspectRatio;
	self.rightConstrailt.constant = 0 * aspectRatio;
	self.viewOffset.constant = -266 * aspectRatio;
	self.heightConstraint.constant = 502 * aspectRatio;
	self.topInfoLabelConstraint.constant = 33 * aspectRatio;
	self.topPromoButtonConstraint.constant = 33 * aspectRatio;
}

- (IBAction)enterPromo:(id)sender
{
	if (nil != self.promoHandler)
	{
		self.promoHandler();
	}
}

@end
