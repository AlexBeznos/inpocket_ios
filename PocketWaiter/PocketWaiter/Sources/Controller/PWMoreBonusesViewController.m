//
//  PWMoreBonusesViewController.m
//  PocketWaiter
//
//  Created by Www Www on 10/2/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWMoreBonusesViewController.h"
#import "PWRestaurant.h"
#import "PWNewReviewViewController.h"

@interface PWMoreBonusesViewController ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *shareHolder;
@property (strong, nonatomic) IBOutlet UIView *commentHolder;
@property (strong, nonatomic) IBOutlet UILabel *shareTitle;
@property (strong, nonatomic) IBOutlet UILabel *shareBonusLabel;
@property (strong, nonatomic) IBOutlet UIImageView *shareBonusImage;
@property (strong, nonatomic) IBOutlet UILabel *commentTitle;
@property (strong, nonatomic) IBOutlet UILabel *commentBonusLabel;
@property (strong, nonatomic) IBOutlet UIImageView *commentBonusImage;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UILabel *commentDescription;
@property (strong, nonatomic) IBOutlet UILabel *shareDescription;

@property (nonatomic) BOOL shareEnabled;
@property (nonatomic) BOOL commentEnabled;
@property (nonatomic) NSUInteger shareBonuses;
@property (nonatomic) NSUInteger commentBonuses;
@property (nonatomic, strong) PWRestaurant *restaurant;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property (nonatomic, weak) id<IPWTransiter> transiter;

@end

@implementation PWMoreBonusesViewController

- (instancetype)initWithRestaurant:(PWRestaurant *) restaurant
			shareEnabled:(BOOL)shareEnabled
			shareBonuses:(NSUInteger)shareBonuses
			commentEnabled:(BOOL)commentEnabled
			commentBonuses:(NSUInteger)commentBonuses
			transiter:(id<IPWTransiter>)transiter
{
	self = [super init];
	
	if (nil != self)
	{
		self.shareEnabled = shareEnabled;
		self.commentEnabled = commentEnabled;
		self.shareBonuses = shareBonuses;
		self.commentBonuses = commentBonuses;
		self.restaurant = restaurant;
		self.transiter = transiter;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setupConstraints];
	
	self.titleLabel.text = @"Еще больше бонусов!";
	
	if (self.shareEnabled)
	{
		self.shareTitle.text = @"Поделиться";
		self.shareDescription.text = @"Поделиться с друзьями в соц. сетях";
		self.shareBonusLabel.text = [NSString stringWithFormat:@"+%li", self.shareBonuses];
		self.shareBonusImage.image = [[UIImage imageNamed:@"collectedBonus"]
					imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		
		self.shareButton.backgroundColor = self.restaurant.color;
		self.shareBonusLabel.textColor = self.restaurant.color;
		self.shareBonusImage.tintColor = self.restaurant.color;
	}
	else
	{
		[self.shareHolder removeFromSuperview];
	}
	
	if (self.commentEnabled)
	{
		self.commentTitle.text = @"Написать коммент";
		self.commentDescription.text = @"Напишите комментарий заведению";
		self.commentBonusLabel.text =  [NSString stringWithFormat:@"+%li", self.commentBonuses];
		self.commentBonusImage.image = [[UIImage imageNamed:@"collectedBonus"]
					imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		
		self.commentButton.backgroundColor = self.restaurant.color;
		self.commentBonusLabel.textColor = self.restaurant.color;
		self.commentBonusImage.tintColor = self.restaurant.color;
	}
	else
	{
		[self.commentHolder removeFromSuperview];
	}
}

- (IBAction)share:(id)sender
{
	PWNewReviewViewController *newReview =
				[[PWNewReviewViewController alloc] initWithType:kPWReviewTypeShareToFriend];
	[self.transiter performForwardTransition:newReview];
}

- (IBAction)comment:(id)sender
{
	PWNewReviewViewController *newReview =
				[[PWNewReviewViewController alloc] initWithType:kPWReviewTypeComment];
	[self.transiter performForwardTransition:newReview];
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
