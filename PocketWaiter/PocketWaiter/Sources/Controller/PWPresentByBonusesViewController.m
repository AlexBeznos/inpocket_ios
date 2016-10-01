//
//  PWPresentByBonusesViewController.m
//  PocketWaiter
//
//  Created by Www Www on 10/1/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWPresentByBonusesViewController.h"
#import "PWSlidesLayout.h"
#import "PWPresentProduct.h"
#import "PWProductCell.h"
#import "PWRestaurant.h"
#import "PWPrice.h"

@interface PWPresentByBonusesViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet PWSlidesLayout *layout;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

@property (nonatomic, weak) id<IPWTransiter> transiter;
@property (nonatomic, strong) NSArray<PWPresentProduct *> *presents;
@property (nonatomic, strong) PWRestaurant *restaurant;

@end

@implementation PWPresentByBonusesViewController

- (instancetype)initWithPresents:(NSArray<PWPresentProduct *> *)presents
			restaurant:(PWRestaurant *)restaurant
			scrollHandler:(void (^)(CGPoint velocity))aHandler
			transiter:(id<IPWTransiter>)transiter
{
	self = [super initWithScrollHandler:aHandler];
	
	if (nil != self)
	{
		self.transiter = transiter;
		self.presents = presents;
		self.restaurant = restaurant;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.translatesAutoresizingMaskIntoConstraints = NO;
	self.label.text = @"Подарки за бонусами";
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
	self.layout.countOfSlides = self.presents.count;
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
	[self.transiter performForwardTransition:[self allItemsController]];
}

- (UIViewController<IPWTransitableController> *)allItemsController
{
	return nil;
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
	// no-op
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
			cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWProductCell *cell = [self.collectionView
				dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
	
	PWPresentProduct *present = [self.presents objectAtIndex:indexPath.item];
	
	[cell.bonusesLabel removeFromSuperview];
	cell.productImageView.image = present.icon;
	cell.getButton.backgroundColor = self.restaurant.color;
	cell.nameLabel.text = present.name;
	cell.priceLabel.text = [NSString stringWithFormat:@"%li бонусов", present.bonusesPrice];
	cell.bonusesImageView.image = [[UIImage imageNamed:@"collectedBonus"]
					imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[cell.bonusesImageView setTintColor:self.restaurant.color];
	__weak __typeof(self) weakSelf = self;
	cell.addToOrderLabel.text = @"+ Добавить в заказ";
	cell.addToOrderHandler =
	^{
		[weakSelf presentAddToOrderForItemAtIndex:[self.presents
					indexOfObject:present]];
	};
	
	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
			numberOfItemsInSection:(NSInteger)section
{
	return self.presents.count;
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
