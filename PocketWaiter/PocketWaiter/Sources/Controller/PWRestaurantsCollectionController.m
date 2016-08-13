//
//  PWDetailedNearRestaurantsController.m
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRestaurantsCollectionController.h"
#import "PWNearRestaurantCollectionViewCell.h"
#import "PWRestaurant.h"
#import "PWRestaurantAboutInfo.h"

@interface PWRestaurantsCollectionController ()

@property (strong, nonatomic) NSArray<PWRestaurant *> *restaurants;

@end

@implementation PWRestaurantsCollectionController

- (instancetype)initWithRestaurants:(NSArray<PWRestaurant *> *)restaurants
{
	self = [super init];
	
	if (nil != self)
	{
		self.restaurants = restaurants;
	}
	
	return self;
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

- (void)registerCell
{
	[self.collectionView registerNib:[UINib
				nibWithNibName:@"PWNearRestaurantCollectionViewCell"
				bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"id"];
}

- (NSString *)navigationTitle
{
	return @"Заведения рядом";
}

- (NSArray *)contentItems
{
	return self.restaurants;
}

- (void)setContentSize:(CGSize)contentSize
{
	UICollectionViewFlowLayout *layout =
				(UICollectionViewFlowLayout *)self.collectionViewLayout;
	
	if (0 != layout.itemSize.width)
	{
		CGFloat aspectRatio = (contentSize.width - 40) / layout.itemSize.width;
		CGFloat height = 0 != layout.itemSize.height ?
					layout.itemSize.height * aspectRatio : 90 * aspectRatio;
		layout.itemSize = CGSizeMake(layout.itemSize.width * aspectRatio, height);
	}
	else
	{
		layout.itemSize = CGSizeMake(contentSize.width - 20, 90);
	}
	
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
}

- (CGFloat)initialCellHeight
{
	return 90;
}

@end
