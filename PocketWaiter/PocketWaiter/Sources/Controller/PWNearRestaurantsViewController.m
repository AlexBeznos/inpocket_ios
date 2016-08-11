//
//  PWnearRestaurantsViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/11/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWNearRestaurantsViewController.h"
#import "PWModelManager.h"
#import "PWNearRestaurantCollectionViewCell.h"

@interface PWNearItemsViewController () <UICollectionViewDataSource,
			UICollectionViewDelegate>

@end

@interface PWNearRestaurantsViewController ()

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSArray<PWRestaurant *> *restaurants;

@end

@implementation PWNearRestaurantsViewController

- (NSString *)nibName
{
	return @"PWNearRestaurantsViewController";
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.collectionView.scrollEnabled = NO;
	self.restaurants = [[PWModelManager sharedManager] nearRestaurants];
}

- (void)setupIndicator
{
	// no-op
}

- (void)setupLayout
{
	self.layout.minimumLineSpacing = 20;
	self.layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
	self.layout.minimumInteritemSpacing = 0;
	 
	self.layout.itemSize = CGSizeMake(320, 90);
	self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
}

- (void)registerCell
{
	[self.collectionView registerNib:[UINib
				nibWithNibName:@"PWNearRestaurantCollectionViewCell"
				bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"id"];
}

- (NSString *)titleDescription
{
	return @"Zavedeniya ryadom";
}

- (NSArray *)contentItems
{
	return self.restaurants;
}

- (void)adjustLayoutWithSize:(CGSize)contentSize
{
	if (0 != self.layout.itemSize.width)
	{
		CGFloat aspectRatio = (contentSize.width - 20) / self.layout.itemSize.width;
		CGFloat height = 0 != self.layout.itemSize.height ? self.layout.itemSize.height * aspectRatio : 90;
		self.layout.itemSize = CGSizeMake(self.layout.itemSize.width * aspectRatio,height);
	}
	else
	{
		self.layout.itemSize = CGSizeMake(contentSize.width - 20, 90);
	}
}

- (CGFloat)fixedContentSpace
{
	return self.layout.minimumLineSpacing * (self.restaurants.count - 1) + 20 + 54;
}

- (CGFloat)resizableContentSpace
{
	return 90 * self.restaurants.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
			cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWNearRestaurantCollectionViewCell *cell = [self.collectionView
				dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
	
	PWRestaurant *restaurant = self.restaurants[indexPath.row];
	cell.title = restaurant.aboutInfo.name;
	cell.descriptionText = restaurant.aboutInfo.restaurantDescription;
	cell.place = restaurant.aboutInfo.address;
	cell.image = restaurant.aboutInfo.restaurantImage;

	return cell;
}

@end
