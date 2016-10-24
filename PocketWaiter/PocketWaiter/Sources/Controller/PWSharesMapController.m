//
//  PWSharesMapController.m
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWSharesMapController.h"
#import "PWRestaurantShare.h"
#import "PWNearRestaurantCollectionViewCell.h"
#import "PWShareViewController.h"
#import "PWImageView.h"

@interface PWMapController ()

- (void)setSelectedIndex:(NSUInteger)selectedIndex updateCamera:(BOOL)update;

@end

@interface PWSharesMapController ()

@property (nonatomic, strong) NSArray<PWRestaurantShare *> *shares;
@property (nonatomic, strong) PWRestaurantShare *selectedShare;

@end

@implementation PWSharesMapController

- (instancetype)initWithShares:(NSArray<PWRestaurantShare *> *)shares
			selectedShare:(PWRestaurantShare *)share
			transiter:(id<IPWTransiter>)transiter
{
	self = [super initWithTransiter:transiter];
	
	if (nil != self)
	{
		self.shares = shares;
		self.selectedShare = share;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setSelectedIndex:[self.shares
				indexOfObject:self.selectedShare] updateCamera:YES];
}

- (NSArray<id<IPWRestaurant>> *)points
{
	return [self.shares valueForKey:@"restaurant"];
}

- (void)setupCell:(PWNearRestaurantCollectionViewCell *)cell
			forItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWRestaurantShare *share = self.shares[indexPath.row];
	cell.title = share.name;
//	cell.descriptionText = share.restaurant.name;
//	cell.place = share.restaurant.address;
	if (nil == share.image)
	{
		NSURL *iconURL = [NSURL URLWithString:share.imagePath];
		[cell.imageView downloadImageFromURL:iconURL completion:
		^(NSURL *localURL)
		{
			share.downloadedImagePath = localURL.path;
		}];
	}
	else
	{
		cell.imageView.image = share.image;
	}
}

- (void)processSelectAtIndex:(NSUInteger)index
{
	PWShareViewController *shareController = [[PWShareViewController alloc]
				initWithShare:self.shares[index]];
	[self.transiter performForwardTransition:shareController];
}

@end
