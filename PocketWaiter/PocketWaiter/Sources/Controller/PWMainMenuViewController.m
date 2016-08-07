//
//  PWMainMenuViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWMainMenuViewController.h"
#import "UIViewControllerAdditions.h"

@interface PWMainMenuViewController ()

@property (nonatomic, copy) PWContentTransitionHandler transitionHandler;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PWMainMenuViewController

- (instancetype)initWithTransitionHandler:(PWContentTransitionHandler)aHandler
{
	self = [super init];
	
	if (nil != self)
	{
		self.transitionHandler = aHandler;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor yellowColor];
	
	[self setupNavigationBar];
	
	[self setupMenuItemWithTarget:self action:@selector(transitionBack)];
	
	UILabel *theTitleLabel = [UILabel new];
	theTitleLabel.text = @"InPocket";
	theTitleLabel.font = [UIFont systemFontOfSize:20];
	[theTitleLabel sizeToFit];
	
	self.navigationItem.leftBarButtonItems =
				@[self.navigationItem.leftBarButtonItem,
				[[UIBarButtonItem alloc] initWithCustomView:theTitleLabel]];
	
	UIButton *theBonusesButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[theBonusesButton setImage:[UIImage imageNamed:@"collectedBonus"]
				forState:UIControlStateNormal];
	[theBonusesButton addTarget:self action:@selector(showBonuses)
				forControlEvents:UIControlEventTouchUpInside];
	[theBonusesButton sizeToFit];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
				initWithCustomView:theBonusesButton];
}

- (void)transitionBack
{
	if (nil != self.transitionHandler)
	{
		self.transitionHandler();
	}
}

- (void)showBonuses
{

}

@end
