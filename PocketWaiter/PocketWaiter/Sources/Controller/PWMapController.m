//
//  PWMapController.m
//  PocketWaiter
//
//  Created by Www Www on 8/14/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWMapController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "IPWRestaurant.h"

@interface PWMapController () <GMSMapViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *mapHolder;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) GMSMapView *mapView;

@end

@implementation PWMapController

- (NSString *)nibName
{
	return @"PWMapController";
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	id<IPWRestaurant> restaurant = [self.points firstObject];
	
	GMSCameraPosition *camera = [GMSCameraPosition
				cameraWithLatitude:restaurant.location.coordinate.latitude
				longitude:restaurant.location.coordinate.longitude zoom:10];
				
	self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
	self.mapView.delegate = self;
	self.mapView.myLocationEnabled = YES;
	
	self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.mapHolder addSubview:self.mapView];
	[self.mapHolder addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil
				views:@{@"view" : self.mapView}]];
	[self.mapHolder addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil
				views:@{@"view" : self.mapView}]];
	
	for (id<IPWRestaurant> restaurant in self.points)
	{
		// Creates a marker in the center of the map.
		GMSMarker *marker = [GMSMarker new];
		marker.position = restaurant.location.coordinate;
		marker.title = restaurant.name;
//		marker.icon = restaurant.restaurantImage;
		marker.map = self.mapView;
	}
}

- (NSArray<id<IPWRestaurant>> *)points
{
	return nil;
}

@end
