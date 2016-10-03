//
//  PWPresentByBonusesViewController.m
//  PocketWaiter
//
//  Created by Www Www on 10/1/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWProductViewController.h"
#import "PWSlidesLayout.h"
#import "PWPresentProduct.h"
#import "PWProductCell.h"
#import "PWRestaurant.h"
#import "PWPrice.h"
#import "PWGridProductsController.h"
#import "PWAddToOrderControler.h"

@interface PWProductViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet PWSlidesLayout *layout;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

@property (nonatomic, weak) id<IPWTransiter> transiter;
@property (nonatomic, strong) NSArray<PWProduct *> *products;
@property (nonatomic, strong) PWRestaurant *restaurant;

@property (nonatomic, strong) NSString *labelTitle;
@property (nonatomic) BOOL isPresents;

@end

@implementation PWProductViewController

- (instancetype)initWithProducts:(NSArray<PWProduct *> *)products
			restaurant:(PWRestaurant *)restaurant
			scrollHandler:(void (^)(CGPoint velocity))aHandler
			transiter:(id<IPWTransiter>)transiter title:(NSString *)title isPresents:(BOOL)isPresent
{
	self = [super initWithScrollHandler:aHandler];
	
	if (nil != self)
	{
		self.transiter = transiter;
		self.products = products;
		self.restaurant = restaurant;
		self.labelTitle = title;
		self.isPresents = isPresent;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.translatesAutoresizingMaskIntoConstraints = NO;
	self.label.text = self.labelTitle;
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	
	[self setupLayout];
	
	[self setupConstraints];
	
	[self registerCell];
}

- (UIView *)scrollHandlerView
{
	return self.collectionView;
}

- (void)setupLayout
{
	self.layout.countOfSlides = self.products.count;
	self.layout.minimumLineSpacing = 20;
	self.layout.sectionInset = UIEdgeInsetsMake(0, 10, 5, 10);
	self.layout.minimumInteritemSpacing = 0;
	 
	self.layout.itemSize = CGSizeMake(150, 240);
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
				nibWithNibName:@"PWProductCell" bundle:[NSBundle mainBundle]]
				forCellWithReuseIdentifier:@"id"];
}

- (void)presentDetailItems
{
	PWGridProductsController *grid = [[PWGridProductsController alloc]
				initWithProducts:self.products restaurant:self.restaurant
				title:self.labelTitle isPresent:self.isPresents];
	grid.view.translatesAutoresizingMaskIntoConstraints = NO;
	grid.contentWidth = self.contentSize.width;
	[self.transiter performForwardTransition:grid];
}

- (void)setContentSize:(CGSize)contentSize
{
	self.widthConstraint.constant = contentSize.width;
	self.heightConstraint.constant = contentSize.height;
	CGFloat aspectRatio = (contentSize.height - 60) / 240.;
	
	self.layout.itemSize = CGSizeMake(aspectRatio * 150,
				contentSize.height - 60);
	
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
}

- (CGSize)contentSize
{
	return CGSizeMake(self.widthConstraint.constant,
				self.heightConstraint.constant);
}

- (void)presentAddToOrderForItemAtIndex:(NSUInteger)index
{
	PWAddToOrderControler *controller = [[PWAddToOrderControler alloc]
				initWithTitle:self.labelTitle product:self.products[index] restaurant:self.restaurant];
	[self.transiter performForwardTransition:controller];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
			cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWProductCell *cell = [self.collectionView
				dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
	
	PWProduct *product = [self.products objectAtIndex:indexPath.item];
	
	if (self.isPresents)
	{
		PWPresentProduct *present = (PWPresentProduct *)product;
		[cell.bonusesLabel removeFromSuperview];
		cell.priceLabel.text = [NSString stringWithFormat:@"%li бонусов", present.bonusesPrice];
	}
	else
	{
		cell.priceLabel.text = product.price.humanReadableValue;
		cell.bonusesLabel.text = [NSString stringWithFormat:@"+%li", product.bonusesValue];
	}
	cell.productImageView.image = product.icon;
	cell.getButton.backgroundColor = self.restaurant.color;
	cell.nameLabel.text = product.name;
	cell.bonusesImageView.image = [[UIImage imageNamed:@"collectedBonus"]
					imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[cell.bonusesImageView setTintColor:self.restaurant.color];
	__weak __typeof(self) weakSelf = self;
	cell.addToOrderLabel.text = @"+ Добавить в заказ";
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
}

- (IBAction)actionPressed:(UIButton *)sender
{
	[self presentDetailItems];
}

@end
