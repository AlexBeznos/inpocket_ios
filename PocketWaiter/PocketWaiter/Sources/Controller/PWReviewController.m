//
//  PWReviewController.m
//  PocketWaiter
//
//  Created by Www Www on 10/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWReviewController.h"
#import "PWRankView.h"
#import "UIColorAdditions.h"

@interface PWReviewController ()

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet PWRankView *rankView;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userIcon;
@property (strong, nonatomic) IBOutlet UIImageView *reviewImage;

@property (nonatomic, strong) PWRestaurantReview *review;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topImageOffset;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftImageOffset;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageHeightMultiplier;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageWidthMultiplier;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *holderLeftOffset;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *holderRightOffset;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *holderBottomOffset;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *holderTopOffset;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topNameLabelOffset;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topDateLabelOffset;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topRankViewOffset;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rankViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commentTopOffset;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commentLeftOffset;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *reviewImageHeight;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

@end

@implementation PWReviewController

- (instancetype)initWithReview:(PWRestaurantReview *)review
{
	self = [super init];
	
	if (nil != self)
	{
		self.review = review;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setupConstraints];
	
	self.view.backgroundColor = [UIColor clearColor];
	
	self.rankView.itemsCount = 5;
	self.rankView.colorSchema = [UIColor pwColorWithAlpha:1];
	self.rankView.rank = self.review.rank - 1;
	self.rankView.userInteractionEnabled = NO;
	self.userNameLabel.text = self.review.userName;
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	dateFormatter.dateStyle = NSDateFormatterMediumStyle;
	self.dateLabel.text = [dateFormatter stringFromDate:self.review.date];
	if (nil != self.review.reviewDescription)
	{
		self.commentLabel.text = self.review.reviewDescription;
	}
	else
	{
		[self.commentLabel removeFromSuperview];
	}
	
	if (nil != self.review.photo)
	{
		self.reviewImage.image = self.review.photo;
	}
	else
	{
		[self.reviewImage removeFromSuperview];
	}
	
	self.userIcon.image = self.review.userIcon;
}

- (void)setupConstraints
{
	self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.view
				attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
				toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:268];
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
	
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
	
	CGFloat commentHeight = 0;
	if (nil != self.review.reviewDescription)
	{
		CGFloat availableCommentWidth = contentWidth -
					self.leftImageOffset.constant - self.holderLeftOffset.constant -
					self.holderRightOffset.constant -
					self.commentLeftOffset.constant - 10;
		
		commentHeight = [self.commentLabel sizeThatFits:
					CGSizeMake(availableCommentWidth, MAXFLOAT)].height + 10;
	}
	
	CGFloat estimatedHeight = commentHeight + self.topImageOffset.constant +
				self.holderTopOffset.constant + self.holderBottomOffset.constant +
				self.topNameLabelOffset.constant + CGRectGetHeight(self.userNameLabel.frame) +
				self.topDateLabelOffset.constant + CGRectGetHeight(self.dateLabel.frame) +
				self.topRankViewOffset.constant + self.rankViewHeight.constant +
				self.commentTopOffset.constant;
	
	if (nil != self.review.photo)
	{
		estimatedHeight += self.reviewImageHeight.constant;
	}

	self.heightConstraint.constant = estimatedHeight;
	
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
