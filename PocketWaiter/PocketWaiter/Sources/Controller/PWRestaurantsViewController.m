//
//  PWRestaurantsViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRestaurantsViewController.h"
#import "PWRestaurantsCollectionController.h"
#import "PWTapper.h"
#import "PWModelManager.h"
#import "UIViewControllerAdditions.h"
#import "UIColorAdditions.h"

@interface PWRestaurantsViewController ()

@property (strong, nonatomic) IBOutlet PWTapper *tapper;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic) BOOL isCollectionMode;

@end

@implementation PWRestaurantsViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.tapper.firstValue = @"СПИСОК";
	self.tapper.secondValue = @"КАРТА";
	self.tapper.tapHandler =
	^(NSUInteger index)
	{
		
	};
	
	__weak __typeof(self) weakSelf = self;
	[[PWModelManager sharedManager] getRestaurantsWithCount:10 offset:0
				completion:^(NSArray<PWRestaurant *> *restaurants)
	{
		PWRestaurantsCollectionController *controller =
					[[PWRestaurantsCollectionController alloc]
					initWithRestaurants:restaurants];
		CGFloat aspectRatio = CGRectGetWidth(weakSelf.parentViewController.
					view.frame) / 320.;
		[controller setContentSize:CGSizeMake(320 * aspectRatio, 90)];
		
		[weakSelf addChildViewController:controller];
		[weakSelf.containerView addSubview:controller.view];
		[controller didMoveToParentViewController:weakSelf];
		controller.view.translatesAutoresizingMaskIntoConstraints = NO;
		[self.containerView addConstraints:[NSLayoutConstraint
					constraintsWithVisualFormat:@"V:|[view]|"
					options:0 metrics:nil
					views:@{@"view" : controller.view}]];
		[self.containerView addConstraints:[NSLayoutConstraint
					constraintsWithVisualFormat:@"H:|[view]|"
					options:0 metrics:nil
					views:@{@"view" : controller.view}]];
	}];
}

- (NSString *)name
{
	return @"Заведения";
}

@end
