//
//  PWShareViewController.m
//  PocketWaiter
//
//  Created by Www Www on 9/4/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWShareViewController.h"
#import "PWRestaurantShare.h"
#import "UIColorAdditions.h"

@interface PWShareViewController ()

@property (nonatomic, strong) PWRestaurantShare *share;
@property (strong, nonatomic) IBOutlet UIImageView *shareImageView;
@property (strong, nonatomic) IBOutlet UILabel *shareDescription;
@property (strong, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (strong, nonatomic) IBOutlet UILabel *getRestaurantLabel;
@property (strong, nonatomic) IBOutlet UILabel *restaurantName;
@property (strong, nonatomic) IBOutlet UILabel *restaurantDescription;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelBottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *holderHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (strong, nonatomic) IBOutlet UIView *contentHolder;

@end

@implementation PWShareViewController

@synthesize transiter;

- (instancetype)initWithShare:(PWRestaurantShare *)share
{
	self = [super init];
	
	if (nil != self)
	{
		self.share = share;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.shareDescription.translatesAutoresizingMaskIntoConstraints = NO;
	self.shareImageView.image = self.share.image;
	self.shareDescription.text = self.share.shareDescription;
	self.restaurantImageView.image = self.share.image;
	self.restaurantName.text = self.share.ownerName;
//	self.restaurantDescription.text =  self.share.restaurant.restaurantDescription;
	self.getRestaurantLabel.text = @"ПОСЕТИТЬ";
	
	self.imageHeight.constant *=
				CGRectGetWidth(self.parentViewController.view.frame) / 320.;
	
	CGFloat height = [self.shareDescription sizeThatFits:CGSizeMake(
				CGRectGetWidth(self.parentViewController.view.frame) - 40, MAXFLOAT)].height;
	self.viewHeight.constant = self.imageTop.constant + self.imageHeight.constant +
				self.labelTop.constant + self.labelBottom.constant +
				self.holderHeight.constant + height;
	
	self.contentHolder.backgroundColor = [UIColor pwBackgroundColor];
	self.view.backgroundColor = [UIColor pwBackgroundColor];
}

- (void)back
{
	[self.transiter performBackTransition];
}

- (void)setupWithNavigationItem:(UINavigationItem *)item
{
	[self setupBackItemWithTarget:self action:@selector(back)
				navigationItem:item];
	
	UILabel *theTitleLabel = [UILabel new];
	theTitleLabel.text = self.share.name;
	theTitleLabel.font = [UIFont systemFontOfSize:20];
	[theTitleLabel sizeToFit];
	
	item.leftBarButtonItems = @[item.leftBarButtonItem,
				[[UIBarButtonItem alloc] initWithCustomView:theTitleLabel]];
	item.rightBarButtonItems = nil;
}

- (IBAction)getRestaurant:(UIButton *)sender
{

}

@end
