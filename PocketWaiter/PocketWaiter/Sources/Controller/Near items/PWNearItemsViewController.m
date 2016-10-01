//
//  PWNearPresentViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWNearItemsViewController.h"
#import "PWIndicator.h"
#import "PWNearItemCollectionViewCell.h"
#import "PWSlidesLayout.h"
#import "PWDetailesItemsViewController.h"

@interface PWNearItemsViewController ()
			<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet PWIndicator *indicator;
@property (strong, nonatomic) IBOutlet PWSlidesLayout *layout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *indicatorWidthConstraint;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

@property (nonatomic, weak) id<IPWTransiter> transiter;

@end

@implementation PWNearItemsViewController

- (instancetype)initWithScrollHandler:
			(void (^)(CGPoint velocity))aHandler
			transiter:(id<IPWTransiter>)transiter
{
	self = [super initWithScrollHandler:aHandler];
	
	if (nil != self)
	{
		self.transiter = transiter;
	}
	
	return self;
}

- (NSString *)nibName
{
	return @"PWNearItemsViewController";
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.translatesAutoresizingMaskIntoConstraints = NO;
	self.titleLabel.text = self.titleDescription;
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	
	[self setupIndicator];
	[self setupLayout];
	
	[self setupConstraints];
	
	[self registerCell];
}

- (UIView *)scrollHandlerView
{
	return self.collectionView;
}

- (void)setupIndicator
{
	self.indicator.itemsCount = self.contentItems.count;
	self.indicator.selectedItemIndex = 0;
	self.indicatorWidthConstraint.constant = 16 * self.contentItems.count;
}

- (void)setupLayout
{
	self.layout.countOfSlides = self.contentItems.count;
	self.layout.minimumLineSpacing = 20;
	self.layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
	self.layout.minimumInteritemSpacing = 0;
	 
	self.layout.itemSize = CGSizeMake(320, 320);
	self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (void)setupConstraints
{
	self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.view
				attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
				toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:320];
	self.widthConstraint = [NSLayoutConstraint constraintWithItem:self.view
				attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
				toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:320];
	
	[self.view addConstraint:self.widthConstraint];
	[self.view addConstraint:self.heightConstraint];
}

- (void)registerCell
{
	[self.collectionView registerNib:[UINib
				nibWithNibName:@"PWNearItemCollectionViewCell"
				bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"id"];
}

- (IBAction)showAllItems:(id)sender
{
	[self presentDetailItems];
}

- (void)presentDetailItems
{
	[self.transiter performForwardTransition:[self allItemsController]];
}

- (PWDetailesItemsViewController *)allItemsController
{
	return nil;
}

- (NSString *)titleDescription
{
	return @"";
}

- (NSArray *)contentItems
{
	return nil;
}

- (void)setContentSize:(CGSize)contentSize
{
	self.widthConstraint.constant = contentSize.width;
	self.heightConstraint.constant = contentSize.height;
	
	[self adjustLayoutWithSize:contentSize];
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
}

- (CGSize)contentSize
{
	return CGSizeMake(self.widthConstraint.constant,
				self.heightConstraint.constant);
}

- (void)adjustLayoutWithSize:(CGSize)contentSize
{
	self.layout.itemSize = CGSizeMake(contentSize.width - 20,
				contentSize.height - 104);
}

- (void)handleScrollToPage:(NSUInteger)aPageNumber
{
	if (0.0f != fmodf(aPageNumber, 1.0f))
	{
		self.indicator.selectedItemIndex = aPageNumber + 1;
	}
	else
	{
		self.indicator.selectedItemIndex = aPageNumber;
	}
}

- (void)setupCell:(PWNearItemCollectionViewCell *)cell
			forItemAtIndexPath:(NSIndexPath *)indexPath
{
	// no-op
}

- (void)presentDetailsForItemAtIndex:(NSUInteger)index
{
	// no-op
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
			cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWNearItemCollectionViewCell *cell = [self.collectionView
				dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
	[self setupCell:cell forItemAtIndexPath:indexPath];
	
	__weak __typeof(self) weakSelf = self;
	cell.moreHandler =
	^{
		[weakSelf presentDetailsForItemAtIndex:indexPath.item];
	};

	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
			numberOfItemsInSection:(NSInteger)section
{
	return self.contentItems.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
	
	CGFloat pageWidth = scrollView.frame.size.width;
	float currentPage = scrollView.contentOffset.x / pageWidth + 0.5;
	
	[self handleScrollToPage:currentPage];
}

@end
