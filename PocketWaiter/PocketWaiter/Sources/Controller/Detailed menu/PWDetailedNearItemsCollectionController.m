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

@interface PWDetailedNearItemsCollectionController ()

@property (nonatomic, weak) id<IPWTransiter> transiter;

@end

@implementation PWDetailedNearItemsCollectionController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithTransiter:(id<IPWTransiter>)transiter
{
	UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
	layout.minimumLineSpacing = 20;
	layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
	layout.minimumInteritemSpacing = 0;
	 
	layout.itemSize = CGSizeMake(320, self.initialCellHeight);
	layout.scrollDirection = UICollectionViewScrollDirectionVertical;
	
	self = [super initWithCollectionViewLayout:layout];
	
	if (nil != self)
	{
		self.transiter = transiter;
	}
	
	return self;
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
	return 420;
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
				itemSize = CGSizeMake(contentSize.width - 40, contentSize.width - 20);
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

- (void)presentDetailsForItemAtIndex:(NSUInteger)index
{
	// no-op
}

#pragma mark <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
			cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWNearItemCollectionViewCell *cell = [self.collectionView
				dequeueReusableCellWithReuseIdentifier:reuseIdentifier
				forIndexPath:indexPath];
	[self setupCell:cell forItemAtIndexPath:indexPath];
	
	__weak __typeof(self) weakSelf = self;
	cell.moreHandler =
	^{
		[weakSelf presentDetailsForItemAtIndex:indexPath.row];
	};

	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
			numberOfItemsInSection:(NSInteger)section
{
	return self.contentItems.count;
}

@end
