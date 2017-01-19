//
//  PWRestaurantMapController.m
//  PocketWaiter
//
//  Created by Www Www on 8/15/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRestaurantMapController.h"
#import "PWRestaurant.h"
#import "PWNearRestaurantCollectionViewCell.h"
#import "PWImageView.h"

@interface PWMapController ()

- (void)setSelectedIndex:(NSUInteger)selectedIndex updateCamera:(BOOL)update;

@end

@interface PWRestaurantMapController ()

@property (nonatomic, strong) NSArray<PWRestaurant *> *restaurants;
@property (nonatomic, strong) PWRestaurant *selectedRestaurant;

@end

@implementation PWRestaurantMapController

- (instancetype)initWithRestaurants:(NSArray<PWRestaurant *> *)restaurants
			selectedRestaurant:(PWRestaurant *)restaurant
			transiter:(id<IPWTransiter>)transiter
{
	self = [super initWithTransiter:transiter];
	
	if (nil != self)
	{
		self.restaurants = restaurants;
		self.selectedRestaurant = restaurant;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
    if (self.selectedRestaurant != nil){
        [self setSelectedIndex:[self.restaurants
                                indexOfObject:self.selectedRestaurant] updateCamera:YES];
    }
}

- (NSArray<id<IPWRestaurant>> *)points
{
	return self.restaurants;
}

- (void)setupCell:(PWNearRestaurantCollectionViewCell *)cell
			forItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWRestaurant *restaurant = self.restaurants[indexPath.row];
	cell.title = restaurant.restaurantName;
	cell.descriptionText = restaurant.restaurantDescription;
	cell.place = restaurant.address;
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
}

@end
