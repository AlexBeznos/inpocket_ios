//
//  PWPhotosController.m
//  PocketWaiter
//
//  Created by Www Www on 10/11/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWPhotosController.h"
#import "PWImageCollectionCell.h"
#import "PWPhotoController.h"

@interface PWPhotosController ()

@property (nonatomic, strong) PWRestaurantAboutInfo *aboutInfo;
@property (nonatomic, strong) NSArray<UIImage *> *items;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation PWPhotosController

@synthesize transiter;

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithAboutInfo:(PWRestaurantAboutInfo *)info
{
	UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
	layout.itemSize = CGSizeMake(100, 100);
	layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
	layout.minimumLineSpacing = 5;
	layout.minimumInteritemSpacing = 5;
	
	self = [super initWithCollectionViewLayout:layout];
	
	if (nil != self)
	{
		self.aboutInfo = info;
		self.items = self.aboutInfo.photos;
		self.layout = layout;
	}
	
	return self;
}

- (void)transitionBack
{
	[self.transiter performBackTransition];
}

- (void)setupWithNavigationItem:(UINavigationItem *)item
{
	[self setupBackItemWithTarget:self action:@selector(transitionBack)
				navigationItem:item];
	
	UILabel *theTitleLabel = [UILabel new];
	theTitleLabel.text = @"Все фото";
	theTitleLabel.font = [UIFont systemFontOfSize:20];
	[theTitleLabel sizeToFit];
	
	item.leftBarButtonItems = @[item.leftBarButtonItem,
				[[UIBarButtonItem alloc] initWithCustomView:theTitleLabel]];
	item.rightBarButtonItems = nil;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.collectionView registerNib:[UINib nibWithNibName:@"PWImageCollectionCell"
				bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
	self.collectionView.backgroundColor = [UIColor darkGrayColor];
}

- (void)setContentWidth:(CGFloat)contentWidth
{
	NSInteger width = (contentWidth - 20) / 3.;
	self.layout.itemSize = CGSizeMake(width, width);
}

- (CGFloat)contentWidth
{
	return self.layout.itemSize.width;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
			cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	PWImageCollectionCell *cell = [collectionView
				dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
	cell.imageView.image = self.items[indexPath.item];
	
	return cell;
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWPhotoController *controller = [[PWPhotoController alloc]
				initWithImage:self.items[indexPath.item] index:indexPath.item count:self.items.count];
	[self.transiter performForwardTransition:controller];
}

@end
