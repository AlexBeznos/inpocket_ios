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
{
	self = [super init];
	
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
	
	[self setSelectedIndex:[self.restaurants
				indexOfObject:self.selectedRestaurant] updateCamera:YES];
}

- (NSArray<id<IPWRestaurant>> *)points
{
	return self.restaurants;
}

- (void)setupCell:(PWNearRestaurantCollectionViewCell *)cell
			forItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWRestaurant *restaurant = self.restaurants[indexPath.row];
	cell.title = restaurant.name;
	cell.descriptionText = restaurant.restaurantDescription;
	cell.place = restaurant.address;
	cell.image = restaurant.restaurantImage;
}

@end
