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
#import "PWImageView.h"

@interface PWRestaurantsCollectionController ()

@property (strong, nonatomic) NSArray<PWRestaurant *> *restaurants;

@end

@implementation PWRestaurantsCollectionController

- (instancetype)initWithRestaurants:(NSArray<PWRestaurant *> *)restaurants
			transiter:(id<IPWTransiter>)transiter
{
	self = [super initWithTransiter:transiter];
	
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
	if (nil == restaurant.restaurantImage)
	{
		NSURL *iconURL = [NSURL URLWithString:restaurant.logoPath];
		[cell.imageView downloadImageFromURL:iconURL completion:
		^(NSURL *localURL)
		{
			restaurant.downloadedLogoURL = localURL.path;
		}];
	}
	else
	{
		cell.imageView.image = restaurant.restaurantImage;
	}

	return cell;
}

- (void)registerCell
{
	[self.collectionView registerNib:[UINib
				nibWithNibName:@"PWNearRestaurantCollectionViewCell"
				bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"id"];
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
					layout.itemSize.height * aspectRatio : 95 * aspectRatio;
		layout.itemSize = CGSizeMake(layout.itemSize.width * aspectRatio, height);
	}
	else
	{
		layout.itemSize = CGSizeMake(contentSize.width - 20, 95);
	}
	
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
}

- (CGFloat)initialCellHeight
{
	return 95;
}

@end
