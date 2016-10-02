//
//  PWThanksForOrderViewController.m
//  PocketWaiter
//
//  Created by Www Www on 10/2/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWThanksForOrderViewController.h"
#import "PWModelManager.h"
#import "UIColorAdditions.h"

@interface PWThanksForOrderViewController ()

@property (nonatomic, strong) PWRestaurant *restaurant;
@property (nonatomic, strong) PWPurchase *purchase;
@property (nonatomic, strong) NSString *navigationTitle;
@property (nonatomic) CGFloat contentWidth;

@end

@implementation PWThanksForOrderViewController

@synthesize transiter;

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant
			purchase:(PWPurchase *)purchase title:(NSString *)title
			contentWidth:(CGFloat)width
{
	self = [super init];
	
	if (nil != self)
	{
		self.restaurant = restaurant;
		self.purchase = purchase;
		self.navigationTitle = title;
		self.contentWidth = width;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
}

- (void)transitionBack
{
	[self.transiter performBackTransition];
}

- (void)setupWithNavigationItem:(UINavigationItem *)item
{
	[self setupBackItemWithTarget:self action:@selector(transitionBack)
				navigationItem:item];
	
	UILabel *theTitleLabel = [UILabel new];
	theTitleLabel.text = self.navigationTitle;
	theTitleLabel.font = [UIFont systemFontOfSize:20];
	[theTitleLabel sizeToFit];
	
	item.leftBarButtonItems = @[item.leftBarButtonItem,
				[[UIBarButtonItem alloc] initWithCustomView:theTitleLabel]];
	item.rightBarButtonItems = nil;
}

@end
