//
//  PWPresentsTabController.m
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWPresentsTabController.h"
#import "PWFirstPresentController.h"
#import "PWRestaurant.h"
#import "PWModelManager.h"

@interface PWPresentsTabController ()

@property (nonatomic, strong) PWRestaurant *restaurant;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation PWPresentsTabController

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant
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
	
	self.scrollView = [UIScrollView new];
	self.scrollView.backgroundColor = [UIColor clearColor];
	self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.scrollView];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
				options:0 metrics:nil views:@{@"view" : self.scrollView}]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
				options:0 metrics:nil views:@{@"view" : self.scrollView}]];
	
	[self startActivity];
	
	__weak __typeof(self) weakSelf = self;
	
	[[PWModelManager sharedManager] getFirstPresentsInfoForUser:
				[[PWModelManager sharedManager] registeredUser] restaurant:self.restaurant
				completion:
	^(PWPresentProduct *firstPresent, NSArray *shares, NSArray *presentByBonuses, NSError *error)
	{
		if (nil != firstPresent)
		{
			[weakSelf stopActivity];
			PWFirstPresentController *firstPresentController =
						[[PWFirstPresentController alloc] initWithPresent:firstPresent
						restaurant:weakSelf.restaurant getPresentHandler:
			^{
				
			}];
			[weakSelf addChildViewController:firstPresentController];
			[weakSelf.scrollView addSubview:firstPresentController.view];
			
			[firstPresentController didMoveToParentViewController:weakSelf];
			firstPresentController.view.translatesAutoresizingMaskIntoConstraints = NO;
			
			[weakSelf.scrollView addConstraints:[NSLayoutConstraint
						constraintsWithVisualFormat:@"V:|[view]"
						options:0 metrics:nil
						views:@{@"view" : firstPresentController.view}]];
			[weakSelf.scrollView addConstraints:[NSLayoutConstraint
						constraintsWithVisualFormat:@"H:|[view]"
						options:0 metrics:nil
						views:@{@"view" : firstPresentController.view}]];
			
			firstPresentController.contentSize = weakSelf.contentSize;
		}
	}];
	
	self.scrollView.contentSize = weakSelf.contentSize;
}

- (void)handleVelocity:(CGPoint)velocity
{
	CGFloat slideFactor = 0.2 * sqrt(velocity.x * velocity.x + velocity.y * velocity.y) / 5000;
	
	CGFloat yOffset = 0;
	
	if (velocity.y > 0)
	{
		CGFloat proposedOffset = self.scrollView.contentOffset.y -
					velocity.y * slideFactor;
		yOffset = proposedOffset > 0 ? proposedOffset : 0;
	}
	else
	{
		CGFloat proposedOffset = self.scrollView.contentOffset.y -
					velocity.y * slideFactor;
		CGFloat maxOffset = self.scrollView.contentSize.height -
					CGRectGetHeight(self.scrollView.frame);
		yOffset = proposedOffset < maxOffset ? proposedOffset : maxOffset;
	}
	NSLog(@"velocity %@ offset %f", NSStringFromCGPoint(velocity), yOffset);
	[self.scrollView setContentOffset:CGPointMake(0, yOffset) animated:YES];
}

@end
