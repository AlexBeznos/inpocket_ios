//
//  PWBestOfDayViewController.m
//  PocketWaiter
//
//  Created by Www Www on 10/3/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWBestOfDayViewController.h"
#import "PWIndicator.h"
#import "PWSlidesLayout.h"
#import "PWBestOfDayProductCell.h"
#import "PWProduct.h"
#import "PWRestaurant.h"
#import "PWPrice.h"
#import "PWAddToOrderControler.h"

@interface PWBestOfDayViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet PWIndicator *indicator;
@property (strong, nonatomic) IBOutlet PWSlidesLayout *layout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *indicatorWidthConstraint;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

@property (nonatomic, weak) id<IPWTransiter> transiter;
@property (nonatomic, strong) PWRestaurant *restaurant;
@property (nonatomic, strong) NSArray<PWProduct *> *products;

@end

@implementation PWBestOfDayViewController

- (instancetype)initWithProducts:(NSArray<PWProduct *> *)products
			restaurant:(PWRestaurant *)restaurant
			scrollHandler:(void (^)(CGPoint velocity))aHandler
			transiter:(id<IPWTransiter>)transiter
{
	self = [super initWithScrollHandler:aHandler];
	
	if (nil != self)
	{
		self.transiter = transiter;
		self.restaurant = restaurant;
		self.products = products;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.translatesAutoresizingMaskIntoConstraints = NO;
	self.titleLabel.text = @"Блюдо дня";
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
	self.indicator.itemsCount = self.products.count;
    self.indicator.colorSchema = [UIColor redColor];
	self.indicator.selectedItemIndex = 0;
	self.indicatorWidthConstraint.constant = 16 * self.products.count;
}

- (void)setupLayout
{
	self.layout.countOfSlides = self.products.count;
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
				nibWithNibName:@"PWBestOfDayProductCell"
				bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"id"];
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

- (void)presentAddToOrderForItemAtIndex:(NSUInteger)index
{
	PWAddToOrderControler *controller = [[PWAddToOrderControler alloc]
				initWithTitle:@"Блюдо дня" product:self.products[index] restaurant:self.restaurant];
	[self.transiter performForwardTransition:controller];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
			cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWBestOfDayProductCell *cell = [self.collectionView
				dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
	
	PWProduct *product = [self.products objectAtIndex:indexPath.item];
	
	cell.priceLabel.text = product.price.humanReadableValue;
	cell.bonusesLabel.text = [NSString stringWithFormat:@"+%li", product.bonusesValue];
    cell.bonusesLabel.textColor = [UIColor redColor];
	cell.productImageView.image = product.icon;
	cell.button.backgroundColor = self.restaurant.color;
	cell.nameLabel.text = product.name;
	cell.bonusesImage.image = [[UIImage imageNamed:@"collectedBonus"]
					imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[cell.bonusesImage setTintColor:self.restaurant.color];
	cell.descriptionLabel.text = product.productDescription;
	__weak __typeof(self) weakSelf = self;
	cell.buttonTitle.text = @"+ Добавить в заказ";
	cell.addToOrderHandler =
	^{
		[weakSelf presentAddToOrderForItemAtIndex:[weakSelf.products
					indexOfObject:product]];
	};

	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
			numberOfItemsInSection:(NSInteger)section
{
	return self.products.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
	
	CGFloat pageWidth = scrollView.frame.size.width;
	float currentPage = scrollView.contentOffset.x / pageWidth + 0.5;
	
	[self handleScrollToPage:currentPage];
}

@end
