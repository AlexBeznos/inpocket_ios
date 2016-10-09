//
//  PWReviewsListViewController.m
//  PocketWaiter
//
//  Created by Www Www on 10/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWReviewsListViewController.h"
#import "PWReviewController.h"
#import "PWButton.h"
#import "UIColorAdditions.h"

@interface PWReviewsListViewController ()

@property (strong, nonatomic) IBOutlet UILabel *allReviewsLabel;
@property (strong, nonatomic) IBOutlet UIView *contentHolder;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelTopOffset;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelBottomOffset;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

@property (nonatomic, strong) NSArray<PWRestaurantReview *> *reviews;
@property (nonatomic, strong) NSMutableArray<PWReviewController *> *reviewControllers;
@property (strong, nonatomic) IBOutlet PWButton *getMoreButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonTopOffset;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomOffset;

@end

@implementation PWReviewsListViewController

- (instancetype)initWithReviews:(NSArray<PWRestaurantReview *> *)reviews
{
	self = [super init];
	
	if (nil != self)
	{
		self.reviews = reviews;
		self.reviewControllers = [NSMutableArray new];
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	self.contentHolder.backgroundColor = [UIColor pwBackgroundColor];
	self.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	self.allReviewsLabel.text = @"Все отзывы";
	[self.allReviewsLabel sizeToFit];
	
	self.getMoreButton.title = @"Посмотреть еще";
	self.getMoreButton.bgColor = [UIColor redColor];
	self.getMoreButton.colorScheme = [UIColor whiteColor];
	
	[self setupConstraints];
	
	NSInteger estimatedHeight = 0;
	UIView *previousView = nil;
	
	for (PWRestaurantReview *review in self.reviews)
	{
		PWReviewController *controller = [[PWReviewController alloc] initWithReview:review];
		controller.view.translatesAutoresizingMaskIntoConstraints = NO;
		[self addChildViewController:controller];
		[self.contentHolder addSubview:controller.view];
		
		[controller didMoveToParentViewController:self];
		if (nil != previousView)
		{
			[self.contentHolder addConstraint:[NSLayoutConstraint
						constraintWithItem:controller.view
						attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
						toItem:previousView
						attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
		}
		else
		{
			[self.contentHolder addConstraints:[NSLayoutConstraint
						constraintsWithVisualFormat:@"V:|[view]"
						options:0 metrics:nil
						views:@{@"view" : controller.view}]];
		}
		[self.contentHolder addConstraints:[NSLayoutConstraint
					constraintsWithVisualFormat:@"H:|[view]"
					options:0 metrics:nil
					views:@{@"view" : controller.view}]];
		
		controller.contentWidth = self.contentWidth;
		previousView = controller.view;
		estimatedHeight += controller.contentSize.height;
		
		[self.reviewControllers addObject:controller];
	}
	
	self.contentHeight.constant = estimatedHeight;
	
	self.heightConstraint.constant = estimatedHeight + self.labelTopOffset.constant +
				self.labelBottomOffset.constant +
				CGRectGetHeight(self.allReviewsLabel.frame) + self.buttonTopOffset.constant +
				self.buttonBottomOffset.constant + self.buttonHeight.constant;
}

- (void)setupConstraints
{
	self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.view
				attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
				toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:600];
	self.widthConstraint = [NSLayoutConstraint constraintWithItem:self.view
				attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
				toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:320];
	
	[self.view addConstraint:self.widthConstraint];
	[self.view addConstraint:self.heightConstraint];
}

- (void)setContentWidth:(CGFloat)contentWidth
{
	self.widthConstraint.constant = contentWidth;
	NSInteger estimatedHeight = 0;
	for (PWReviewController *controller in self.reviewControllers)
	{
		controller.contentWidth = contentWidth;
		estimatedHeight += controller.contentSize.height;
	}
	
	self.heightConstraint.constant = estimatedHeight + self.labelTopOffset.constant +
				self.labelBottomOffset.constant +
				CGRectGetHeight(self.allReviewsLabel.frame) + self.buttonTopOffset.constant +
				self.buttonBottomOffset.constant + self.buttonHeight.constant;
	self.contentHeight.constant = estimatedHeight;
}

- (CGFloat)contentWidth
{
	return self.widthConstraint.constant;
}

- (CGSize)contentSize
{
	return CGSizeMake(self.widthConstraint.constant,
				self.heightConstraint.constant);
}

- (IBAction)getMore:(id)sender
{
}

@end
