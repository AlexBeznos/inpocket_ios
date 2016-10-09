//
//  PWWriteNewReviewController.m
//  PocketWaiter
//
//  Created by Www Www on 10/8/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWWriteNewReviewController.h"

@interface PWWriteNewReviewController ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *buttonTitle;
@property (strong, nonatomic) PWRestaurant *restaurant;
@property (nonatomic, copy) void (^handler)();

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

@end

@implementation PWWriteNewReviewController

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant newReviewHandler:(void (^)())handler
{
	self = [super init];
	
	if (nil != self)
	{
		self.restaurant = restaurant;
		self.handler = handler;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.titleLabel.text = @"Напишите отзыв";
	self.descriptionLabel.text = @"Нам очень важно ваше мнение, поэтому мы "\
				"будем начислять вам бонусы за оставленные комментарии";
	self.buttonTitle.text = @"Написать отзыв";
	
	[self setupConstraints];
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

- (IBAction)buttonAction:(id)sender
{
	if (nil != self.handler)
	{
		self.handler();
	}
}

@end
