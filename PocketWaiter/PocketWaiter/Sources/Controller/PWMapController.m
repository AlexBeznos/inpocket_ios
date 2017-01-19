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
#import "UIColorAdditions.h"
#import "PWNearRestaurantCollectionViewCell.h"
#import "PWSlidesLayout.h"
#import "UIImageAdditions.h"

@interface PWRestaurantHolder : NSObject

@property (nonatomic, strong) id<IPWRestaurant> point;
@property (nonatomic, strong) GMSMarker *marker;

@end

@implementation PWRestaurantHolder

@end

@interface PWMapController () <GMSMapViewDelegate,
			UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *mapHolder;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet PWSlidesLayout *layout;

@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) GMSMutableCameraPosition *camera;

@property (nonatomic, strong) NSMutableArray<PWRestaurantHolder *> *holders;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic) BOOL markerTransitionInProgress;

@property (nonatomic, weak) id<IPWTransiter> transiter;

@end

@implementation PWMapController

- (instancetype)initWithTransiter:(id<IPWTransiter>)transiter
{
	self = [super init];
	
	if (nil != self)
	{
		self.transiter = transiter;
	}
	
	return self;
}

- (NSString *)nibName
{
	return @"PWMapController";
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.holders = [NSMutableArray array];
	
    if (self.selectedIndex > 0) {
        id<IPWRestaurant> restaurant = self.points[self.selectedIndex];
        
        self.camera = [[GMSMutableCameraPosition alloc]
                    initWithTarget:restaurant.location.coordinate zoom:12 bearing:0 viewingAngle:0];
    }
				
	self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:self.camera];
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
		GMSMarker *marker = [GMSMarker new];
        marker.position = restaurant.location.coordinate;
		marker.title = restaurant.restaurantName;
		marker.icon = [UIImage markerImageWithState:NO scheme:restaurant.color
					logo:restaurant.restaurantImage];
		marker.map = self.mapView;
		
		PWRestaurantHolder *holder = [PWRestaurantHolder new];
		holder.point = restaurant;
		holder.marker = marker;
		[self.holders addObject:holder];
	}
	
	self.collectionView.backgroundColor = [UIColor pwBackgroundColor];
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	
	[self.collectionView registerNib:[UINib
				nibWithNibName:@"PWNearRestaurantCollectionViewCell"
				bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"id"];
	
	self.layout.countOfSlides = self.points.count;
	self.layout.minimumLineSpacing = 10;
	self.layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
	self.layout.minimumInteritemSpacing = 0;
	 
	self.layout.itemSize = CGSizeMake(320, 95);
	self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (void)setContentSize:(CGSize)contentSize
{
	if (0 != self.layout.itemSize.width)
	{
		CGFloat aspectRatio = (contentSize.width - 20) / self.layout.itemSize.width;
		CGFloat height = 0 != self.layout.itemSize.height ?
					self.layout.itemSize.height * aspectRatio : 95 * aspectRatio;
		self.layout.itemSize =
					CGSizeMake(self.layout.itemSize.width * aspectRatio, height);
	}
	else
	{
		self.layout.itemSize = CGSizeMake(contentSize.width - 20, 95);
	}
	
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
}

- (NSArray<id<IPWRestaurant>> *)points
{
	return nil;
}

- (id<IPWRestaurant>)selectedPoint
{
	return self.holders[self.selectedIndex].point;
}

- (GMSMarker *)selectedMarker
{
	return self.holders[self.selectedIndex].marker;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex updateCamera:(BOOL)update
{
	if (selectedIndex != _selectedIndex)
	{
		_selectedIndex = selectedIndex;
		
		if (update)
		{
			self.camera.target = self.selectedPoint.location.coordinate;
			self.camera.zoom = 12;
			self.mapView.selectedMarker = self.selectedMarker;
			[self.mapView moveCamera:[GMSCameraUpdate
						setTarget:self.selectedPoint.location.coordinate]];
		}
	}
}

- (void)processSelectAtIndex:(NSUInteger)index
{
	// no-op
}

- (void)setupCell:(PWNearRestaurantCollectionViewCell *)cell
			forItemAtIndexPath:(NSIndexPath *)indexPath
{
	// no-op
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
			cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWNearRestaurantCollectionViewCell *cell = [self.collectionView
				dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
	
	[self setupCell:cell forItemAtIndexPath:indexPath];

	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
			numberOfItemsInSection:(NSInteger)section
{
	return self.points.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[self processSelectAtIndex:indexPath.item];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
	
	CGFloat pageWidth = scrollView.frame.size.width;
	float currentPage = scrollView.contentOffset.x / pageWidth + 0.5;
	
	[self setSelectedIndex:(NSUInteger)currentPage
				updateCamera:!self.markerTransitionInProgress];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
	NSInteger currentPage = 0;
	
	for (PWRestaurantHolder *holder in self.holders)
	{
		if (holder.marker == marker)
		{
			currentPage = [self.holders indexOfObject:holder];
			break;
		}
	}
	
	CGFloat leftOffset = self.layout.sectionInset.left;
	CGFloat allWidth = self.layout.collectionViewContentSize.width;
	CGFloat insetWidth = (allWidth - 2 * leftOffset -
				self.points.count * self.layout.itemSize.width) /
				(self.points.count - 1);
	
	self.markerTransitionInProgress = YES;
	[UIView animateWithDuration:0.25 animations:
	^{
		[self.collectionView setContentOffset:CGPointMake(currentPage *
						(insetWidth + self.layout.itemSize.width), 0)];
	}
				completion:^(BOOL finished)
	{
		self.selectedIndex = currentPage;
		self.markerTransitionInProgress = NO;
	}];
				
	return YES;
}

@end
