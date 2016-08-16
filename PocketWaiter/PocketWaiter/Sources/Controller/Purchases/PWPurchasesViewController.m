//
//  PWPurchasesViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWPurchasesViewController.h"
#import "PWModelManager.h"
#import "PWActivityIndicator.h"
#import "UIColorAdditions.h"

@interface PWPurchasesViewController ()

@property (nonatomic, strong) NSArray<PWPurchase *> *purchases;
@property (nonatomic, strong) PWUser *user;
@property (nonatomic, strong) PWActivityIndicator *activity;

@end

@implementation PWPurchasesViewController

@synthesize transiter;

- (instancetype)initWithUser:(PWUser *)user
{
	self = [super init];
	
	if (nil != self)
	{
		self.user = user;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	
	__weak __typeof(self) theWeakSelf = self;
	[self startActivity];
	
	[[PWModelManager sharedManager] getPurchasesForUser:self.user
				withCount:20 offset:0 completion:^(NSArray<PWPurchase *> *purchases)
	{
		theWeakSelf.purchases = purchases;
		[theWeakSelf stopActivity];
	}];
}

- (void)startActivity
{
	if (!self.activity.animating)
	{
		[self.view addSubview:self.activity];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
					attribute:NSLayoutAttributeCenterX
					relatedBy:NSLayoutRelationEqual toItem:self.activity
					attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
					attribute:NSLayoutAttributeCenterY
					relatedBy:NSLayoutRelationEqual toItem:self.activity
					attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
		[self.activity startAnimating];
	}
}

- (void)stopActivity
{
	if (self.activity.animating)
	{
		[self.activity stopAnimating];
		[self.activity removeFromSuperview];
	}
}

- (PWActivityIndicator *)activity
{
	if (nil == _activity)
	{
		_activity = [PWActivityIndicator new];
		_activity.translatesAutoresizingMaskIntoConstraints = NO;
		[_activity addConstraint:[NSLayoutConstraint constraintWithItem:_activity
					attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
					toItem:nil attribute:NSLayoutAttributeNotAnAttribute
					multiplier:1.0 constant:40]];
		[_activity addConstraint:[NSLayoutConstraint constraintWithItem:_activity
					attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
					toItem:nil attribute:NSLayoutAttributeNotAnAttribute
					multiplier:1.0 constant:40]];
	}
	
	return _activity;
}

- (void)setupWithNavigationItem:(UINavigationItem *)item
{
	[self setupBackItemWithTarget:self action:@selector(transitionBack)
				navigationItem:item];
	
	UILabel *theTitleLabel = [UILabel new];
	theTitleLabel.text = @"Бонусы";
	theTitleLabel.font = [UIFont systemFontOfSize:20];
	[theTitleLabel sizeToFit];
	
	item.leftBarButtonItems = @[item.leftBarButtonItem,
				[[UIBarButtonItem alloc] initWithCustomView:theTitleLabel]];
	item.rightBarButtonItem = nil;
}

- (void)transitionBack
{
	[self.transiter performBackTransitionWithSetupNavigationItem:YES];
}

@end
