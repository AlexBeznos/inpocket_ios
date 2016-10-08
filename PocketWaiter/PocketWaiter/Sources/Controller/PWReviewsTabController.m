//
//  PWReviewsTabController.m
//  PocketWaiter
//
//  Created by Www Www on 10/8/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWReviewsTabController.h"
#import "PWRestaurant.h"
#import "PWWriteNewReviewController.h"

@interface PWReviewsTabController ()

@property (nonatomic, strong) PWRestaurant *restaurant;

@end

@implementation PWReviewsTabController

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant
			isActive:(BOOL)isActive
{
	self = [super init];
	
	if (nil != self)
	{
		self.restaurant = restaurant;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self startActivity];
	__weak __typeof(self) weakSelf = self;
	[[PWModelManager sharedManager] getCommentsInfoForRestaurant:self.restaurant
				completion:^(BOOL allowComment, NSArray<PWRestaurantReview *> *reviews)
	{
		NSInteger estimatedHeight = 0;
		UIView *previousView = nil;
		if (allowComment)
		{
			[weakSelf stopActivity];
			PWWriteNewReviewController *writeComment =
						[[PWWriteNewReviewController alloc] initWithRestaurant:weakSelf.restaurant];
			[weakSelf addChildViewController:writeComment];
			[weakSelf.scrollView addSubview:writeComment.view];
			
			[writeComment didMoveToParentViewController:weakSelf];
			writeComment.view.translatesAutoresizingMaskIntoConstraints = NO;
			
			[weakSelf.scrollView addConstraints:[NSLayoutConstraint
						constraintsWithVisualFormat:@"V:|[view]"
						options:0 metrics:nil
						views:@{@"view" : writeComment.view}]];
			[weakSelf.scrollView addConstraints:[NSLayoutConstraint
						constraintsWithVisualFormat:@"H:|[view]"
						options:0 metrics:nil
						views:@{@"view" : writeComment.view}]];
			
			writeComment.contentSize = CGSizeMake(weakSelf.contentWidth, 0.6 * weakSelf.contentWidth);
			previousView = writeComment.view;
			estimatedHeight += writeComment.contentSize.height;
		}
		
		weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.contentWidth, estimatedHeight);
	}];
	
	self.scrollView.contentSize = CGSizeMake(self.contentWidth, self.contentWidth);
}

@end
