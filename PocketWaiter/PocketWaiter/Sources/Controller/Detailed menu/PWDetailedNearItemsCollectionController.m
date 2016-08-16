//
//  PWDetailledNearItemsController.m
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWDetailedNearItemsCollectionController.h"
#import "PWNearItemCollectionViewCell.h"
#import "UIColorAdditions.h"
#import "UIViewControllerAdditions.h"

@implementation PWDetailedNearItemsCollectionController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
	UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
	layout.minimumLineSpacing = 20;
	layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
	layout.minimumInteritemSpacing = 0;
	 
	layout.itemSize = CGSizeMake(320, self.initialCellHeight);
	layout.scrollDirection = UICollectionViewScrollDirectionVertical;
	
	return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.collectionView.backgroundColor = [UIColor pwBackgroundColor];
	self.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self registerCell];
}

- (CGFloat)initialCellHeight
{
	return 320;
}

- (void)registerCell
{
	[self.collectionView registerNib:
				[UINib nibWithNibName:@"PWNearItemCollectionViewCell"
				bundle:[NSBundle mainBundle]]
				forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)setContentSize:(CGSize)contentSize
{
	((UICollectionViewFlowLayout *)self.collectionViewLayout).
				itemSize = CGSizeMake(contentSize.width - 40, contentSize.width - 40);
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
}

- (void)setupCell:(PWNearItemCollectionViewCell *)cell
			forItemAtIndexPath:(NSIndexPath *)indexPath
{
	// no-op
}

- (NSArray *)contentItems
{
	return nil;
}

#pragma mark <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
			cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWNearItemCollectionViewCell *cell = [self.collectionView
				dequeueReusableCellWithReuseIdentifier:reuseIdentifier
				forIndexPath:indexPath];
	
	[self setupCell:cell forItemAtIndexPath:indexPath];

	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
			numberOfItemsInSection:(NSInteger)section
{
	return self.contentItems.count;
}


#pragma mark <UICollectionViewDelegate>

@end