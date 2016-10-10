//
//  PWShareCommentViewController.m
//  PocketWaiter
//
//  Created by Www Www on 10/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWShareCommentViewController.h"

@interface PWShareCommentViewController ()

@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UILabel *buttonTitle;
@property (strong, nonatomic) IBOutlet UILabel *bonusesCount;
@property (strong, nonatomic) IBOutlet UIImageView *bonusesImage;
@property (strong, nonatomic) IBOutlet UILabel *shareDescription;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

@end

@implementation PWShareCommentViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setupConstraints];
	
	self.buttonTitle.text = @"Написать коммент";
	self.shareDescription.text = @"Напишите комментарий заведению";
	self.bonusesCount.text =  [NSString stringWithFormat:@"+20"];
	self.bonusesImage.image = [[UIImage imageNamed:@"collectedBonus"]
				imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	
	self.button.backgroundColor = [UIColor redColor];
	self.bonusesCount.textColor = [UIColor redColor];
	self.bonusesImage.tintColor = [UIColor redColor];
}

- (void)setupConstraints
{
	self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.view
				attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
				toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:140];
	self.widthConstraint = [NSLayoutConstraint constraintWithItem:self.view
				attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
				toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:320];
	
	[self.view addConstraint:self.widthConstraint];
	[self.view addConstraint:self.heightConstraint];
}

- (void)setContentWidth:(CGFloat)contentWidth
{
	self.widthConstraint.constant = contentWidth;
	self.heightConstraint.constant = contentWidth * 0.45;
	
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
}

- (CGFloat)contentWidth
{
	return self.widthConstraint.constant;
}

- (CGSize)contentSize
{
	return CGSizeMake(self.widthConstraint.constant,
				self.heightConstraint.constant);
}

@end
