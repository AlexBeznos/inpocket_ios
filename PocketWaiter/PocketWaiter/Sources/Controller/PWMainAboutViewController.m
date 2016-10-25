//
//  PWMainAboutViewController.m
//  PocketWaiter
//
//  Created by Www Www on 10/10/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWMainAboutViewController.h"
#import "PWIndicator.h"
#import "PWImageCollectionCell.h"
#import "PWSlidesLayout.h"
#import "PWPhotosController.h"

#import "UIColorAdditions.h"

@interface PWMainAboutViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet PWSlidesLayout *layout;
@property (strong, nonatomic) IBOutlet PWIndicator *indicator;
@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *restaurantTypeLabel;
@property (strong, nonatomic) IBOutlet UITextView *locationView;
@property (strong, nonatomic) IBOutlet UITextView *numberView;
@property (strong, nonatomic) IBOutlet UITextView *linkView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

@property (nonatomic, strong) PWRestaurantAboutInfo *aboutInfo;
@property (nonatomic, weak) id<IPWTransiter> transiter;

@end

@implementation PWMainAboutViewController

- (instancetype)initWithRestaurantInfo:(PWRestaurantAboutInfo *)about transiter:(id<IPWTransiter>)transiter
{
	self = [super init];
	
	if (nil != self)
	{
		self.aboutInfo = about;
		self.transiter = transiter;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	
	[self setupConstraints];
	
	self.restaurantNameLabel.text = self.aboutInfo.name;
	self.restaurantTypeLabel.text = self.aboutInfo.restaurantDescription;
	self.locationView.text = self.aboutInfo.address;
	NSMutableString *phoneNumbers = [NSMutableString string];
	for (NSString *number in self.aboutInfo.phoneNumbers)
	{
		[phoneNumbers appendFormat:@"%@\n", number];
	}
	self.numberView.text = phoneNumbers;
	self.linkView.text = self.aboutInfo.webLink;
	
	self.indicator.backgroundColor = [UIColor clearColor];
	self.indicator.itemsCount = self.aboutInfo.photos.count;
	self.indicator.selectedItemIndex = 0;
	
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	[self.collectionView registerNib:[UINib nibWithNibName:@"PWImageCollectionCell"
				bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"id"];
	self.collectionView.backgroundColor = [UIColor clearColor];
	
	self.layout.countOfSlides = self.aboutInfo.photos.count;
	self.layout.minimumLineSpacing = 20;
	self.layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
	self.layout.minimumInteritemSpacing = 0;
	 
	self.layout.itemSize = CGSizeMake(320, 320);
	self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
			cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWImageCollectionCell *cell = [self.collectionView
				dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
	cell.imageView.image = self.aboutInfo.photos[indexPath.row];

	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
			numberOfItemsInSection:(NSInteger)section
{
	return self.aboutInfo.photos.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
	
	CGFloat pageWidth = scrollView.frame.size.width;
	float currentPage = scrollView.contentOffset.x / pageWidth + 0.5;
	
	[self handleScrollToPage:currentPage];
}

- (void)collectionView:(UICollectionView *)collectionView
			didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWPhotosController *photosController = [[PWPhotosController alloc]
				initWithAboutInfo:self.aboutInfo];
	photosController.contentWidth = self.contentSize.width;
	[self.transiter performForwardTransition:photosController];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
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

- (void)setContentWidth:(CGFloat)width
{
	self.widthConstraint.constant = width;
	self.heightConstraint.constant = 1.7 * width;
	
	self.layout.itemSize = CGSizeMake(width * 0.8, width * 0.7);
	self.collectionViewHeight.constant = width * 0.7 + 20;
	
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
}

- (CGSize)contentSize
{
	return CGSizeMake(self.widthConstraint.constant,
				self.heightConstraint.constant);
}

- (IBAction)openMap:(id)sender
{
}

- (IBAction)call:(id)sender
{
}

- (IBAction)goToBrowser:(id)sender
{
}

@end
