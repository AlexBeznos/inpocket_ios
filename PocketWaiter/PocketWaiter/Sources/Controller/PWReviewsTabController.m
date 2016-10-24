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
#import "PWReviewsListViewController.h"
#import "PWNewReviewViewController.h"

@interface PWReviewsTabController ()

@property (nonatomic, strong) PWRestaurant *restaurant;
@property (nonatomic, weak) id<IPWTransiter> transiter;
@property (nonatomic) BOOL defaultMode;

@end

@implementation PWReviewsTabController

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
	[[PWModelManager sharedManager] getCommentsInfoForRestaurant:self.restaurant page:0 completion:
				^(NSArray<PWRestaurantReview *> *reviews, NSError *error)
	{
		[weakSelf stopActivity];
		
		if (nil == error)
		{
			PWWriteNewReviewController *writeComment =
						[[PWWriteNewReviewController alloc]
						initWithRestaurant:weakSelf.restaurant
						newReviewHandler:
			^{
				PWNewReviewViewController *newReview =
							[[PWNewReviewViewController alloc] initWithType:kPWReviewTypeComment];
				[weakSelf.transiter performForwardTransition:newReview];
			}];
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
			UIView *previousView = writeComment.view;
			NSInteger estimatedHeight = writeComment.contentSize.height;
			
			if (reviews.count > 0)
			{
				PWReviewsListViewController *reviewsList =
							[[PWReviewsListViewController alloc] initWithReviews:reviews];
				
				reviewsList.view.translatesAutoresizingMaskIntoConstraints = NO;
				[weakSelf addChildViewController:reviewsList];
				[weakSelf.scrollView addSubview:reviewsList.view];
				
				[reviewsList didMoveToParentViewController:weakSelf];
				
				if (nil != previousView)
				{
					[weakSelf.scrollView addConstraint:[NSLayoutConstraint
								constraintWithItem:reviewsList.view
								attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
								toItem:previousView
								attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
				}
				else
				{
					[weakSelf.scrollView addConstraints:[NSLayoutConstraint
								constraintsWithVisualFormat:@"V:|[view]"
								options:0 metrics:nil
								views:@{@"view" : reviewsList.view}]];
				}
				[weakSelf.scrollView addConstraints:[NSLayoutConstraint
							constraintsWithVisualFormat:@"H:|[view]"
							options:0 metrics:nil
							views:@{@"view" : reviewsList.view}]];
				
				reviewsList.contentWidth = self.contentWidth;
				
				previousView = reviewsList.view;
				estimatedHeight += reviewsList.contentSize.height;
			}
			
			weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.contentWidth, estimatedHeight);
		}
		else
		{
			[weakSelf showNoInternetDialog];
		}
	}];
	
	self.scrollView.contentSize = CGSizeMake(self.contentWidth, self.contentWidth);
}

@end
