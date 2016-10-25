//
//  PWAllPurchasesViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/24/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWAllPurchasesViewController.h"
#import "PWModelManager.h"
#import "PWIndicator.h"
#import "PWCollectionView.h"
#import "PWPurchaseRestaurantCell.h"
#import "PWSlidesLayout.h"
#import "UIColorAdditions.h"
#import "PWRestaurantPurchasesController.h"
#import "UIViewControllerAdditions.h"
#import "PWPurchasesPlainController.h"

@interface PWAllPurchasesViewController ()
			<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray<PWRestaurant *> *restaurants;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sliderHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *indicatorHeight;
@property (nonatomic, strong) PWUser *user;
@property (strong, nonatomic) IBOutlet PWCollectionView *cardsView;
@property (strong, nonatomic) IBOutlet UILabel *purchasesLabel;
@property (strong, nonatomic) IBOutlet UIView *purchasesContainer;
@property (strong, nonatomic) IBOutlet PWIndicator *indicator;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *indicatorTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *indicatorLeft;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *indicatorBottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *indicatorWidth;
@property (strong, nonatomic) IBOutlet PWSlidesLayout *layout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (strong, nonatomic) IBOutlet UIView *contentHolder;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelBottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *sliderOffset;

@property (strong, nonatomic) PWRestaurantPurchasesController *currentPaysController;
@property (strong, nonatomic) PWRestaurantPurchasesController *nextPaysController;
@property (strong, nonatomic) PWRestaurantPurchasesController *previousPaysController;

@property (strong, nonatomic) NSLayoutConstraint *firstAnimatableConstraint;
@property (strong, nonatomic) NSLayoutConstraint *secondAnimatableConstraint;
@property (strong, nonatomic) NSLayoutConstraint *thirdAnimatableConstraint;
@property (nonatomic) CGFloat lastOffset;
@property (nonatomic) NSUInteger currentIndex;
@property (strong, nonatomic) id<IPWTransiter> transiter;

@end

@implementation PWAllPurchasesViewController

- (instancetype)initWithUser:(PWUser *)user
			restaurants:(NSArray<PWRestaurant *> *)restaurants
			transiter:(id<IPWTransiter>)transiter
{
	self = [super init];
	
	if (nil != self)
	{
		self.user = user;
		self.restaurants = restaurants;
		self.transiter = transiter;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	self.cardsView.backgroundColor = [UIColor pwBackgroundColor];
	self.cardsView.allowsSelection = YES;
	self.indicator.backgroundColor = [UIColor pwBackgroundColor];
	self.contentHolder.backgroundColor = [UIColor pwBackgroundColor];
	self.purchasesContainer.backgroundColor = [UIColor pwBackgroundColor];
	
	self.purchasesLabel.text = @"ИСТОРИЯ ПОКУПОК";
	
	self.indicator.itemsCount = self.restaurants.count;
	self.indicator.selectedItemIndex = 0;
	
	self.layout.countOfSlides = self.restaurants.count;
	self.layout.minimumLineSpacing = 0;
	self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
	self.layout.minimumInteritemSpacing = 0;
	 
	self.layout.itemSize = CGSizeMake(320, 210);
	self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	
	self.contentHeight.constant = 500;
	
	if (self.restaurants.count == 1)
	{
		[self.indicator removeFromSuperview];
		self.cardsView.userInteractionEnabled = NO;
	}
	else
	{
		if (nil == self.indicator.superview)
		{
			self.indicator.translatesAutoresizingMaskIntoConstraints = NO;
			[self.view addSubview:self.indicator];
			[self.view addConstraints:@[self.indicatorTop, self.indicatorLeft,
						self.indicatorBottom]];
		}
		self.indicatorWidth.constant = 16 * self.restaurants.count;
		self.cardsView.userInteractionEnabled = YES;
	}
	
	__weak __typeof(self) weakSelf = self;
	self.cardsView.delegate = self;
	self.cardsView.dataSource = self;
	self.cardsView.contentOffsetObserver = ^(CGPoint offset)
	{
		[weakSelf slidePurchasesWithOffset:offset.x];
	};
	
	[self.cardsView registerNib:[UINib nibWithNibName:@"PWPurchaseRestaurantCell"
				bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"id"];
	
	UIView *holder = [UIView new];
	holder.backgroundColor = [UIColor clearColor];
	holder.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.purchasesContainer addSubview:holder];
	
	[self.purchasesContainer addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]|"
				options:0 metrics:nil views:@{@"view" :holder}]];
	[self.purchasesContainer addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]|"
				options:0 metrics:nil views:@{@"view" :holder}]];
	
	self.currentPaysController = [[PWRestaurantPurchasesController alloc] initWithUser:self.user estimatedHeightHandler:
	^(CGFloat height)
	{
		[weakSelf adjustContentHeightWithPurchasesHeight:height];
	}];
	[self.currentPaysController updateWithRestaurant:self.restaurants[0]];
	
	[self addChildViewController:self.currentPaysController];
	[holder addSubview:self.currentPaysController.view];
	[self.currentPaysController didMoveToParentViewController:self];
	self.currentPaysController.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.currentPaysController.view addConstraint:[NSLayoutConstraint
				constraintWithItem:self.currentPaysController.view
				attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
				toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:CGRectGetWidth(self.parentViewController.view.frame)]];
	
	self.previousPaysController = [[PWRestaurantPurchasesController alloc] initWithUser:self.user estimatedHeightHandler:
	^(CGFloat height)
	{
		[weakSelf adjustContentHeightWithPurchasesHeight:height];
	}];
	
	[self addChildViewController:self.previousPaysController];
	[holder addSubview:self.previousPaysController.view];
	[self.previousPaysController didMoveToParentViewController:self];
	self.previousPaysController.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.previousPaysController.view addConstraint:[NSLayoutConstraint
				constraintWithItem:self.previousPaysController.view
				attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
				toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:CGRectGetWidth(self.parentViewController.view.frame)]];
	
	self.nextPaysController = [[PWRestaurantPurchasesController alloc] initWithUser:self.user estimatedHeightHandler:
	^(CGFloat height)
	{
		[weakSelf adjustContentHeightWithPurchasesHeight:height];
	}];
	
	[self addChildViewController:self.nextPaysController];
	[holder addSubview:self.nextPaysController.view];
	[self.nextPaysController didMoveToParentViewController:self];
	self.nextPaysController.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.nextPaysController.view addConstraint:[NSLayoutConstraint
				constraintWithItem:self.nextPaysController.view
				attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
				toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:CGRectGetWidth(self.parentViewController.view.frame)]];
	
	[holder addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : self.currentPaysController.view}]];
	[holder addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : self.previousPaysController.view}]];
	[holder addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : self.nextPaysController.view}]];
	
	self.firstAnimatableConstraint = [NSLayoutConstraint constraintWithItem:
				holder attribute:NSLayoutAttributeLeft
				relatedBy:NSLayoutRelationEqual toItem: self.previousPaysController.view
				attribute:NSLayoutAttributeLeft multiplier:1.0
				constant:-CGRectGetWidth(self.parentViewController.view.frame)];
	self.secondAnimatableConstraint = [NSLayoutConstraint constraintWithItem:
				holder attribute:NSLayoutAttributeLeft
				relatedBy:NSLayoutRelationEqual toItem:self.currentPaysController.view
				attribute:NSLayoutAttributeLeft multiplier:1.0
				constant:0];
	self.thirdAnimatableConstraint = [NSLayoutConstraint constraintWithItem:
				holder attribute:NSLayoutAttributeLeft
				relatedBy:NSLayoutRelationEqual toItem:self.nextPaysController.view
				attribute:NSLayoutAttributeLeft multiplier:1.0
				constant:CGRectGetWidth(self.parentViewController.view.frame)];
	[holder addConstraints:@[self.firstAnimatableConstraint,
				self.secondAnimatableConstraint, self.thirdAnimatableConstraint]];
}

- (void)setupChildControllers:(UIViewController *)controller
			leftOffset:(CGFloat)left rightOffset:(CGFloat)right
{
	[self addChildViewController:controller];
	[self.purchasesContainer addSubview:controller.view];
	[controller didMoveToParentViewController:self];
	controller.view.translatesAutoresizingMaskIntoConstraints = NO;
	[self.purchasesContainer addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]|"
				options:0 metrics:nil
				views:@{@"view" : controller.view}]];
	[self.purchasesContainer addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]|"
				options:0 metrics:@{@"left" : @(left), @"right" : @(right)}
				views:@{@"view" : controller.view}]];
}

- (void)adjustContentHeightWithPurchasesHeight:(CGFloat)height
{
	self.contentHeight.constant = height + (nil != self.indicator.superview ? self.indicatorHeight.constant +
				self.indicatorBottom.constant : 0) + self.indicatorTop.constant +
				self.sliderHeight.constant + self.labelBottom.constant +
				self.labelHeight.constant + self.sliderOffset.constant;
}

- (void)slidePurchasesWithOffset:(CGFloat)offset
{
	if (offset != self.lastOffset && offset >= 0 && offset <=
				(self.restaurants.count - 1) * CGRectGetWidth(self.parentViewController.view.frame))
	{
		self.firstAnimatableConstraint.constant = offset -
					CGRectGetWidth(self.parentViewController.view.frame) * (1 + self.currentIndex);
		self.secondAnimatableConstraint.constant = offset -
					CGRectGetWidth(self.parentViewController.view.frame) * self.currentIndex;
		self.thirdAnimatableConstraint.constant = offset -
					CGRectGetWidth(self.parentViewController.view.frame) * (self.currentIndex - 1);
		
		CGFloat ratio = offset / CGRectGetWidth(self.parentViewController.view.frame);
		NSUInteger pageIndex = (NSInteger)ratio;
		if (ratio == pageIndex && pageIndex != self.currentIndex)
		{
			PWRestaurantPurchasesController *currentController = self.currentPaysController;
			NSLayoutConstraint *currentConstraint = self.secondAnimatableConstraint;
			
			if (self.lastOffset < offset)
			{
				self.currentPaysController = self.previousPaysController;
				self.secondAnimatableConstraint = self.firstAnimatableConstraint;
				
				self.previousPaysController = self.nextPaysController;
				self.firstAnimatableConstraint = self.thirdAnimatableConstraint;
				
				self.nextPaysController = currentController;
				self.thirdAnimatableConstraint = currentConstraint;
				
				self.firstAnimatableConstraint.constant = -CGRectGetWidth(self.parentViewController.view.frame);
			}
			else
			{
				self.currentPaysController = self.nextPaysController;
				self.secondAnimatableConstraint = self.thirdAnimatableConstraint;
				
				self.nextPaysController = self.previousPaysController;
				self.thirdAnimatableConstraint = self.firstAnimatableConstraint;
				
				self.previousPaysController = currentController;
				self.firstAnimatableConstraint = currentConstraint;
				
				self.thirdAnimatableConstraint.constant = CGRectGetWidth(self.parentViewController.view.frame);
			}
			[self.currentPaysController updateWithRestaurant:self.restaurants[pageIndex]];
			[self.previousPaysController updateWithRestaurant:nil];
			[self.nextPaysController updateWithRestaurant:nil];
			
			self.currentIndex = pageIndex;
		}
		
		self.lastOffset = offset;
	}
}

- (void)setWidth:(CGFloat)contentWidth
{
	self.layout.itemSize = CGSizeMake(contentWidth, 210);
	self.contentWidth.constant = contentWidth;
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
			numberOfItemsInSection:(NSInteger)section
{
	return self.restaurants.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
			cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWPurchaseRestaurantCell *cell = [collectionView
				dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
	
	PWRestaurant *restaurant = self.restaurants[indexPath.row];
	
	cell.color = restaurant.color;
	cell.image = restaurant.restaurantImage;
	cell.bonusesCount = restaurant.aboutInfo.collectedBonuses;
	cell.name = restaurant.restaurantName;
	cell.descriptionText = restaurant.restaurantDescription;
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	__weak __typeof(self) weakSelf = self;
	PWPurchasesPlainController *controller = [[PWPurchasesPlainController alloc]
				initWithRestaurants:self.restaurants restaurantHandler:
	^(PWRestaurant *restaurant)
	{
		CGFloat offset = CGRectGetWidth(weakSelf.parentViewController.view.frame) *
					[weakSelf.restaurants indexOfObject:restaurant];
		[weakSelf slidePurchasesWithOffset:offset];
		[weakSelf.cardsView setContentOffset:CGPointMake(offset, 0)];
		[weakSelf handleScrollToPage:[weakSelf.restaurants indexOfObject:restaurant]];
	}];
	[controller setWidth:CGRectGetWidth(self.parentViewController.view.frame)];
	[self.transiter performForwardTransition:controller];
}

- (void)handleScrollToPage:(NSUInteger)aPageNumber
{
	if (0.0f != fmodf(aPageNumber, 1.0f))
	{
		self.indicator.selectedItemIndex = aPageNumber + 1;
	}
	else
	{
		self.indicator.selectedItemIndex = aPageNumber;
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
	
	CGFloat pageWidth = scrollView.frame.size.width;
	float currentPage = scrollView.contentOffset.x / pageWidth + 0.5;
	
	[self handleScrollToPage:currentPage];
}

@end
