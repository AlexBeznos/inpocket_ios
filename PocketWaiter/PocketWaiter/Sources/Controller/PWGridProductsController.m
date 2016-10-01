//
//  PWGridProductsController.m
//  PocketWaiter
//
//  Created by Www Www on 10/1/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWGridProductsController.h"
#import "PWPresentProduct.h"
#import "PWRestaurant.h"
#import "PWProductCell.h"
#import "UIColorAdditions.h"

@interface PWGridProductsController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSArray<PWPresentProduct *> *presents;
@property (nonatomic, strong) PWRestaurant *restaurant;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation PWGridProductsController

@synthesize transiter;

- (instancetype)initWithPresents:(NSArray<PWPresentProduct *> *)presents
			restaurant:(PWRestaurant *)restaurant
{
	self = [super init];
	
	if (nil != self)
	{
		self.presents = presents;
		self.restaurant = restaurant;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.scrollView removeFromSuperview];
	
	self.layout = [UICollectionViewFlowLayout new];
	self.layout.minimumLineSpacing = 20;
	self.layout.sectionInset = UIEdgeInsetsMake(0, 10, 5, 10);
	self.layout.minimumInteritemSpacing = 20;
	 
	self.layout.itemSize = CGSizeMake(140, 240);
	self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
	
	self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
				collectionViewLayout:self.layout];
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.collectionView];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
				options:0 metrics:nil views:@{@"view" : self.collectionView}]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
				options:0 metrics:nil views:@{@"view" : self.collectionView}]];
	[self registerCell];
	self.collectionView.backgroundColor = [UIColor pwBackgroundColor];
}

- (void)transitionBack
{
	[self.transiter performBackTransition];
}

- (void)setupWithNavigationItem:(UINavigationItem *)item
{
	[self setupBackItemWithTarget:self action:@selector(transitionBack)
				navigationItem:item];
	
	UILabel *theTitleLabel = [UILabel new];
	theTitleLabel.text = @"Подарки за бонусами";
	theTitleLabel.font = [UIFont systemFontOfSize:20];
	[theTitleLabel sizeToFit];
	
	item.leftBarButtonItems = @[item.leftBarButtonItem,
				[[UIBarButtonItem alloc] initWithCustomView:theTitleLabel]];
	item.rightBarButtonItems = nil;
}

- (void)registerCell
{
	[self.collectionView registerNib:[UINib
				nibWithNibName:@"PWProductCell" bundle:[NSBundle mainBundle]]
				forCellWithReuseIdentifier:@"id"];
}

- (void)setContentWidth:(CGFloat)contentWidth
{
	CGFloat aspectRatio = contentWidth / 320;
	
	self.layout.itemSize = CGSizeMake(140 * aspectRatio,
				aspectRatio * 240);
	
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
}

- (CGFloat)contentWidth
{
	return self.layout.itemSize.width;
}

- (void)presentAddToOrderForItemAtIndex:(NSUInteger)index
{
	// no-op
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
			cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWProductCell *cell = [self.collectionView
				dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
	
	PWPresentProduct *present = [self.presents objectAtIndex:indexPath.item];
	
	[cell.bonusesLabel removeFromSuperview];
	cell.productImageView.image = present.icon;
	cell.getButton.backgroundColor = self.restaurant.color;
	cell.nameLabel.text = present.name;
	cell.priceLabel.text = [NSString stringWithFormat:@"%li бонусов", present.bonusesPrice];
	cell.bonusesImageView.image = [[UIImage imageNamed:@"collectedBonus"]
					imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[cell.bonusesImageView setTintColor:self.restaurant.color];
	__weak __typeof(self) weakSelf = self;
	cell.addToOrderLabel.text = @"+ Добавить в заказ";
	cell.addToOrderHandler =
	^{
		[weakSelf presentAddToOrderForItemAtIndex:[self.presents
					indexOfObject:present]];
	};
	
	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
			numberOfItemsInSection:(NSInteger)section
{
	return self.presents.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];
}

@end
