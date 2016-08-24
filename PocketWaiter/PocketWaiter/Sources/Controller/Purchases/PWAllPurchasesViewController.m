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

@interface PWAllPurchasesViewController ()
			<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray<PWRestaurant *> *restaurants;
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

@end

@implementation PWAllPurchasesViewController

- (instancetype)initWithUser:(PWUser *)user purchases:(NSArray<PWRestaurant *> *)restaurants
{
	self = [super init];
	
	if (nil != self)
	{
		self.user = user;
		self.restaurants = restaurants;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	self.cardsView.backgroundColor = [UIColor pwBackgroundColor];
	self.indicator.backgroundColor = [UIColor pwBackgroundColor];
	self.contentHolder.backgroundColor = [UIColor pwBackgroundColor];
	
	self.purchasesLabel.text = @"ИСТОРИЯ ПОКУПОК";
	
	self.indicator.itemsCount = self.restaurants.count;
	self.indicator.selectedItemIndex = 0;
	
	self.layout.countOfSlides = self.restaurants.count;
	self.layout.minimumLineSpacing = 0;
	self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
	self.layout.minimumInteritemSpacing = 0;
	 
	self.layout.itemSize = CGSizeMake(320, 210);
	self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	
	if (self.restaurants.count == 1)
	{
		[self.indicator removeFromSuperview];
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
	}
	
	self.cardsView.delegate = self;
	self.cardsView.dataSource = self;
	self.cardsView.contentOffsetObserver = ^(CGPoint offsset)
	{
	
	};
	
	[self.cardsView registerNib:[UINib nibWithNibName:@"PWPurchaseRestaurantCell"
				bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"id"];
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
	
	return cell;
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
