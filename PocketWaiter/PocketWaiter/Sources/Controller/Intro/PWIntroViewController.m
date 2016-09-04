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
#import "UIColorAdditions.h"

@interface PWIntroViewController () <UICollectionViewDataSource,
			UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet PWIndicator *indicator;
@property (strong, nonatomic) IBOutlet UICollectionView *slidesView;
@property (strong, nonatomic) IBOutlet PWIntroLayout *layout;
@property (strong, nonatomic) IBOutlet UIButton *skipButton;
@property (strong, nonatomic) IBOutlet UILabel *label;

@property (nonatomic, strong) PWEnterPromoViewController *enterPromoController;

@property (nonatomic, copy) void (^completion)();

@end

@implementation PWIntroViewController

- (instancetype)initWithCompletionHandler:(void (^)())aCompletion
{
	self = [super init];
	
	if (nil != self)
	{
		self.completion = aCompletion;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.indicator.itemsCount = 3;
	self.indicator.selectedItemIndex = 0;
	self.indicator.backgroundColor = [UIColor clearColor];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	self.slidesView.backgroundColor =[UIColor pwBackgroundColor];
	
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
	
	self.label.text = @"Далее";
}

- (IBAction)skipPressed:(id)sender
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
		if (nil != self.completion)
		{
			self.completion();
			self.completion = nil;
		}
	}
}

- (void)showPromo
{
	self.enterPromoController = [PWEnterPromoViewController new];
	[self.enterPromoController showWithCompletion:nil];
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
	
	self.label.text = 2 == aPageNumber ? @"Начать пользоваться" : @"Далее";
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
	
	theCell.backgroundColor = [UIColor pwBackgroundColor];
	
	return theCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
	[aScrollView setContentOffset:CGPointMake(aScrollView.contentOffset.x,0)];
	
	CGFloat pageWidth = self.slidesView.frame.size.width;
	float currentPage = self.slidesView.contentOffset.x / pageWidth + 0.5;
	
	[self handleScrollToPage:currentPage];
}

@end
