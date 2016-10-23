//
//  PWAboutUsTabController.m
//  PocketWaiter
//
//  Created by Www Www on 10/10/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWAboutUsTabController.h"
#import "PWMainAboutViewController.h"

@interface PWAboutUsTabController ()

@property (nonatomic, strong) PWRestaurant *restaurant;
@property (nonatomic, weak) id<IPWTransiter> transiter;
@property (nonatomic) BOOL defaultMode;

@end

@implementation PWAboutUsTabController

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant
			transiter:(id<IPWTransiter>)transiter defaultMode:(BOOL)defaultMode
{
	self = [super init];
	
	if (nil != self)
	{
		self.restaurant = restaurant;
		self.transiter = transiter;
		self.defaultMode = defaultMode;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self startActivity];
	__weak __typeof(self) weakSelf = self;
	
	[[PWModelManager sharedManager] getAboutInfoForRestaurant:self.restaurant
				completion:^(PWRestaurantAboutInfo *info, NSError *error)
	{
		[weakSelf stopActivity];
		
		if (nil != info)
		{
			NSInteger estimatedHeight = 0;
			UIView *previousView = nil;
			PWMainAboutViewController *aboutInfoController =
						[[PWMainAboutViewController alloc]
						initWithRestaurantInfo:info transiter:self.transiter];
			[weakSelf addChildViewController:aboutInfoController];
			[weakSelf.scrollView addSubview:aboutInfoController.view];
			
			[aboutInfoController didMoveToParentViewController:weakSelf];
			aboutInfoController.view.translatesAutoresizingMaskIntoConstraints = NO;
			
			[weakSelf.scrollView addConstraints:[NSLayoutConstraint
						constraintsWithVisualFormat:@"V:|[view]"
						options:0 metrics:nil
						views:@{@"view" : aboutInfoController.view}]];
			[weakSelf.scrollView addConstraints:[NSLayoutConstraint
						constraintsWithVisualFormat:@"H:|[view]"
						options:0 metrics:nil
						views:@{@"view" : aboutInfoController.view}]];
			
			aboutInfoController.contentWidth = weakSelf.contentWidth;
			previousView = aboutInfoController.view;
			estimatedHeight += aboutInfoController.contentSize.height;
			
			weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.contentWidth, estimatedHeight);
		}
	}];
	
	self.scrollView.contentSize = CGSizeMake(self.contentWidth, self.contentWidth);
}

@end
