//
//  PWThankForReviewViewController.m
//  PocketWaiter
//
//  Created by Www Www on 10/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWThankForReviewViewController.h"
#import "PWThanksForController.h"
#import "UIColorAdditions.h"
#import "PWShareCommentViewController.h"

@interface PWThankForReviewViewController ()

@property (nonatomic, weak) id<IPWTransiter> transiter;
@property (nonatomic, strong) PWRestaurantReview *review;

@end

@implementation PWThankForReviewViewController

- (instancetype)initWithReview:(PWRestaurantReview *)review transiter:(id<IPWTransiter>)transiter
{
	self = [super init];
	
	if (nil != self)
	{
		self.transiter = transiter;
		self.review = review;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	__weak __typeof(self) weakSelf = self;
	PWThanksForController *controller = [[PWThanksForController alloc]
				initWithType:kPWItemTypeComment
				scheme:[UIColor redColor] bonusesCount:50 backHandler:
	^{
		[weakSelf.transiter performBackTransitionToRoot];
	}];
	
	NSInteger estimatedHeight = 0;
	__block UIView *previousView = nil;
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
	
	controller.contentSize = CGSizeMake(self.contentWidth, self.contentWidth * 0.95);
	previousView = controller.view;
	estimatedHeight +=controller.contentSize.height;
	self.scrollView.contentSize = CGSizeMake(weakSelf.contentWidth, estimatedHeight);

	PWShareCommentViewController *shareController =
				[[PWShareCommentViewController alloc] initWithReview:weakSelf.review];
	[weakSelf addChildViewController:shareController];
	[weakSelf.scrollView addSubview:shareController.view];
	
	[shareController didMoveToParentViewController:self];
	shareController.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	[weakSelf.scrollView addConstraint:[NSLayoutConstraint
				constraintWithItem:shareController.view
				attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
				toItem:previousView
				attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
	
	[weakSelf.scrollView addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]"
				options:0 metrics:nil
				views:@{@"view" : shareController.view}]];
	
	shareController.contentWidth = weakSelf.contentWidth;
	weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.contentWidth,
				estimatedHeight + shareController.contentSize.height);

}
@end
