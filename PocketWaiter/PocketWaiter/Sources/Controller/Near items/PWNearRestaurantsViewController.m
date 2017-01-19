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
#import "PWDetailedRestaurantsViewController.h"
#import "PWImageView.h"

@interface PWNearItemsViewController () <UICollectionViewDataSource,
			UICollectionViewDelegate>

- (void)presentDetailItems;

@end

@interface PWNearRestaurantsViewController ()

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSArray<PWRestaurant *> *restaurants;

@end

@implementation PWNearRestaurantsViewController

- (instancetype)initWithRestaurants:(NSArray<PWRestaurant *> *)restaurants
			scrollHandler:(void (^)(CGPoint velocity))aHandler
			transiter:(id<IPWTransiter>)transiter
{
	self = [super initWithScrollHandler:aHandler transiter:transiter];
	
	if (nil != self)
	{
		self.restaurants = restaurants;
	}
	
	return self;
}

- (NSString *)nibName
{
	return @"PWNearRestaurantsViewController";
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.collectionView.scrollEnabled = NO;
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
	 
	self.layout.itemSize = CGSizeMake(320, 100);
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
	return @"Заведения рядом";
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
		CGFloat height = 0 != self.layout.itemSize.height ? self.layout.itemSize.height * aspectRatio : 95;
		self.layout.itemSize = CGSizeMake(self.layout.itemSize.width * aspectRatio,height);
	}
	else
	{
		self.layout.itemSize = CGSizeMake(contentSize.width - 20, 95);
	}
}

- (CGFloat)fixedContentSpace
{
	return self.layout.minimumLineSpacing * (self.restaurants.count - 1) + 20 + 54;
}

- (CGFloat)resizableContentSpace
{
	return 95 * self.restaurants.count;
}

- (IBAction)showDetailsRestaurants:(id)sender
{
	[self presentDetailItems];
}

- (PWDetailesItemsViewController *)allItemsController
{
	PWDetailedRestaurantsViewController *controller =
				[[PWDetailedRestaurantsViewController alloc]
				initWithRestaurants:self.restaurants];
	
	return controller;
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

@end
