//
//  PWPresentsMapController.m
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWPresentsMapController.h"
#import "PWPresentProduct.h"
#import "PWNearRestaurantCollectionViewCell.h"
#import "PWImageView.h"

@interface PWMapController ()

- (void)setSelectedIndex:(NSUInteger)selectedIndex updateCamera:(BOOL)update;

@end

@interface PWPresentsMapController ()

@property (nonatomic, strong) NSArray<PWPresentProduct *> *presents;
@property (nonatomic, strong) PWPresentProduct *selectedPresent;

@end

@implementation PWPresentsMapController

- (instancetype)initWithPresents:(NSArray<PWPresentProduct *> *)presents
			selectedPresent:(PWPresentProduct *)present
			transiter:(id<IPWTransiter>)transiter
{
	self = [super initWithTransiter:transiter];
	
	if (nil != self)
	{
		self.presents = presents;
		self.selectedPresent = present;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setSelectedIndex:[self.presents
				indexOfObject:self.selectedPresent] updateCamera:YES];
}

- (NSArray<id<IPWRestaurant>> *)points
{
	return [self.presents valueForKey:@"restaurant"];
}

- (void)setupCell:(PWNearRestaurantCollectionViewCell *)cell
			forItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWPresentProduct *present = self.presents[indexPath.row];
	cell.title = present.name;
	cell.descriptionText = present.ownerName;
//	cell.place = present.restaurant.address;
	if (nil == present.icon)
	{
		NSURL *iconURL = [NSURL URLWithString:present.iconPath];
		[cell.imageView downloadImageFromURL:iconURL completion:
		^(NSURL *localURL)
		{
			present.downloadedIconPath = localURL.path;
		}];
	}
	else
	{
		cell.imageView.image =present.icon;
	}
}

@end
