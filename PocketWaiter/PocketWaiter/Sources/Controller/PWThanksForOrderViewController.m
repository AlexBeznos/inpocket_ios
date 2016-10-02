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
#import "PWThanksForOrderHolderController.h"

@interface PWThanksForOrderViewController ()

@property (nonatomic, strong) PWRestaurant *restaurant;
@property (nonatomic, strong) PWPurchase *purchase;
@property (nonatomic, strong) NSString *navigationTitle;
@property (nonatomic) CGFloat contentWidth;
@property (nonatomic) BOOL firstPresent;

@end

@implementation PWThanksForOrderViewController

@synthesize transiter;

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant
			purchase:(PWPurchase *)purchase title:(NSString *)title
			contentWidth:(CGFloat)width isFirstPresent:(BOOL)firstPresent
{
	self = [super init];
	
	if (nil != self)
	{
		self.restaurant = restaurant;
		self.purchase = purchase;
		self.navigationTitle = title;
		self.contentWidth = width;
		self.firstPresent = firstPresent;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	__weak __typeof(self) weakSelf = self;
	PWThanksForOrderHolderController *controller = [[PWThanksForOrderHolderController alloc]
				initWithRestaurant:self.restaurant purchase:self.purchase
				backHandler:
	^{
		[weakSelf.transiter performBackTransitionToRoot];
	} isFirstPresent:self.firstPresent];
	
	NSInteger estimatedHeight = 0;
	UIView *previousView = nil;
	[self addChildViewController:controller];
	[self.scrollView addSubview:controller.view];
	
	[controller didMoveToParentViewController:weakSelf];
	controller.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.scrollView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]"
				options:0 metrics:nil
				views:@{@"view" : controller.view}]];
	[self.scrollView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]"
				options:0 metrics:nil
				views:@{@"view" : controller.view}]];
	
	controller.contentSize = CGSizeMake(self.contentWidth, self.contentWidth * 0.7);
	previousView = controller.view;
	estimatedHeight +=controller.contentSize.height;
	self.scrollView.contentSize = CGSizeMake(weakSelf.contentWidth, estimatedHeight);
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
