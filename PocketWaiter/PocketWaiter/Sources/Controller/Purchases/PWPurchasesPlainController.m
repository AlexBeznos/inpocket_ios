//
//  PWPurchasesPlainController.m
//  PocketWaiter
//
//  Created by Www Www on 9/4/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWPurchasesPlainController.h"
#import "PWPurchaseRestaurantCell.h"
#import "UIColorAdditions.h"
#import "PWModelManager.h"

@interface PWPurchasesPlainController ()

@property (nonatomic, strong) NSArray<PWRestaurant *> *restaurants;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (nonatomic, copy) void (^handler)(PWRestaurant *);

@end

@implementation PWPurchasesPlainController

@synthesize transiter;

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithRestaurants:(NSArray<PWRestaurant *> *)restaurants
			restaurantHandler:(void (^)(PWRestaurant *))handler
{
	self.layout = [UICollectionViewFlowLayout new];
	self.layout.minimumLineSpacing = 0;
	self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
	self.layout.minimumInteritemSpacing = 0;
	 
	self.layout.itemSize = CGSizeMake(320, 210);
	self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
	
	self =  [super initWithCollectionViewLayout:self.layout];
	
	if (nil != self)
	{
		self.handler = handler;
		self.restaurants = restaurants;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.collectionView.backgroundColor = [UIColor pwBackgroundColor];
	self.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self registerCell];
}

- (void)registerCell
{
	[self.collectionView registerNib:
				[UINib nibWithNibName:@"PWPurchaseRestaurantCell"
				bundle:[NSBundle mainBundle]]
				forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)setWidth:(CGFloat)contentWidth
{
	self.layout.itemSize = CGSizeMake(contentWidth, 210);
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
}

- (void)back
{
	[self.transiter performBackTransition];
}

- (void)setupWithNavigationItem:(UINavigationItem *)item
{
	[self setupBackItemWithTarget:self action:@selector(back)
				navigationItem:item];
	
	UILabel *theTitleLabel = [UILabel new];
	theTitleLabel.text = @"Бонусы";
	theTitleLabel.font = [UIFont systemFontOfSize:20];
	[theTitleLabel sizeToFit];
	
	item.leftBarButtonItems = @[item.leftBarButtonItem,
				[[UIBarButtonItem alloc] initWithCustomView:theTitleLabel]];
	item.rightBarButtonItem = nil;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView
			numberOfItemsInSection:(NSInteger)section
{
	return self.restaurants.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
			cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWPurchaseRestaurantCell *cell = [collectionView
				dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	
	PWRestaurant *restaurant = self.restaurants[indexPath.row];
	
	cell.color = restaurant.color;
	cell.image = restaurant.restaurantImage;
	// TODO: hardcoded value
	cell.bonusesCount = 100;
	cell.name = restaurant.restaurantName;
	cell.descriptionText = restaurant.restaurantDescription;
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
			didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (nil != self.handler)
	{
		self.handler(self.restaurants[indexPath.row]);
		[self back];
	}
}

@end
