//
//  PWIntroViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/6/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWIntroViewController.h"
#import "PWIndicator.h"
#import "PWIntroFirstPageCell.h"
#import "PWIntroLayout.h"
#import "PWIntroFirstPageCell.h"
#import "PWEnterPromoViewController.h"

@interface PWIntroViewController () <UICollectionViewDataSource,
			UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet PWIndicator *indicator;
@property (strong, nonatomic) IBOutlet UICollectionView *slidesView;
@property (strong, nonatomic) IBOutlet PWIntroLayout *layout;
@property (strong, nonatomic) IBOutlet UIButton *skipButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) PWEnterPromoViewController *enterPromoController;

@end

@implementation PWIntroViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.indicator.itemsCount = 3;
	self.indicator.selectedItemIndex = 0;
	
	self.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
	self.slidesView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
	
	self.layout.countOfSlides = 3;
	self.layout.minimumLineSpacing = 0;
	self.layout.minimumInteritemSpacing = 0;
	CGFloat aspectRatio = CGRectGetWidth(self.parentViewController.view.frame) / 320.;
	 
	self.layout.itemSize = CGSizeMake(aspectRatio * 320, aspectRatio * 452);
	self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	
	[self.slidesView registerNib:[UINib nibWithNibName:@"PWIntroFirstPageCell"
				bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"first"];
	[self.slidesView registerNib:[UINib nibWithNibName:@"PWIntroSecondPageCell"
				bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"second"];
	
	[self.slidesView registerNib:[UINib nibWithNibName:@"PWIntroThirdPageCell"
				bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"third"];
	self.slidesView.dataSource = self;
	self.slidesView.delegate = self;
	self.automaticallyAdjustsScrollViewInsets = NO;
	
	[self.skipButton setTitle:@"Далее" forState:UIControlStateNormal];
}

- (IBAction)nextPressed:(id)sender
{
	CGFloat pageWidth = self.slidesView.frame.size.width;
	float currentPage = self.slidesView.contentOffset.x / pageWidth;
	
	if (2 != currentPage)
	{
		[self.slidesView scrollToItemAtIndexPath:
					[NSIndexPath indexPathForRow:currentPage + 1 inSection:0]
					atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
	}
	else
	{
		[self skipPressed:nil];
	}
}

- (IBAction)skipPressed:(id)sender
{

}

- (void)showPromo
{
	self.enterPromoController = [PWEnterPromoViewController new];
	[self.enterPromoController showWithCompletion:nil];
}

#pragma mark - data source

- (NSInteger)collectionView:(UICollectionView *)collectionView
			numberOfItemsInSection:(NSInteger)section
{
	return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
			cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *theCell = nil;
	
	if (0 == indexPath.row)
	{
		PWIntroFirstPageCell *slideCell = [self.slidesView
					dequeueReusableCellWithReuseIdentifier:@"first"
					forIndexPath:indexPath];
		slideCell.aspectRatio =
					CGRectGetWidth(self.parentViewController.view.frame) / 320.;
		theCell = slideCell;
	}
	else if (1 == indexPath.row)
	{
		PWIntroSecondPageCell *slideCell = [self.slidesView
					dequeueReusableCellWithReuseIdentifier:@"second"
					forIndexPath:indexPath];
		slideCell.aspectRatio =
					CGRectGetWidth(self.parentViewController.view.frame) / 320.;
		theCell = slideCell;
	}
	else
	{
		__weak __typeof (self) theWeakSelf = self;
		PWIntroThirdPageCell *slideCell = [self.slidesView
					dequeueReusableCellWithReuseIdentifier:@"third"
					forIndexPath:indexPath];
		slideCell.promoHandler =
		^{
			[theWeakSelf showPromo];
		};
		
		slideCell.aspectRatio =
					CGRectGetWidth(self.parentViewController.view.frame) / 320.;
		theCell = slideCell;
	}
	
	return theCell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGFloat pageWidth = self.slidesView.frame.size.width;
	float currentPage = self.slidesView.contentOffset.x / pageWidth;
	
	if (0.0f != fmodf(currentPage, 1.0f))
	{
		self.indicator.selectedItemIndex = currentPage + 1;
	}
	else
	{
		self.indicator.selectedItemIndex = currentPage;
	}
	
	[self.skipButton setTitle:2 == currentPage ? @"Начать пользоваться" : @"Далее"
				forState:UIControlStateNormal];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
	[aScrollView setContentOffset:CGPointMake(aScrollView.contentOffset.x,0)];
}

@end
