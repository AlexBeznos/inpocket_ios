//
//  PWRestaurantFilterController.m
//  PocketWaiter
//
//  Created by Www Www on 8/14/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRestaurantFilterController.h"
#import "PWRestaurantFilterCell.h"
#import "UIColorAdditions.h"

@interface PWFilterHolder : NSObject

@property (nonatomic) PWRestaurantType filter;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *icon;

@end

@implementation PWFilterHolder

@end

@interface PWRestaurantFilterController ()
			<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *showButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic, copy) void (^completion)(PWRestaurantType type);
@property (nonatomic, strong) NSArray<PWFilterHolder *> *filters;
@property (nonatomic, strong) NSMutableArray<PWFilterHolder *> *selectedFilters;
@property (nonatomic, strong) PWFilterHolder *allFilterHolder;
@property (nonatomic) PWRestaurantType currentType;

@end

@implementation PWRestaurantFilterController

@synthesize transiter;

- (instancetype)initWithCurrentFilter:(PWRestaurantType)filter typeHandler:
			(void (^)(PWRestaurantType type))aHandler
{
	self = [super init];
	
	if (nil != self)
	{
		self.completion = aHandler;

		self.selectedFilters = [NSMutableArray new];
		self.currentType = filter;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.collectionView.backgroundColor = [UIColor pwBackgroundColor];
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	
	NSMutableArray *initialSelectedFilters = [NSMutableArray new];
	for (PWFilterHolder *holder in self.filters)
	{
		if (holder.filter == (holder.filter & self.currentType))
		{
			[initialSelectedFilters addObject:holder];
			if (holder == self.allFilterHolder)
			{
				break;
			}
		}
	}
	
	[self.selectedFilters addObjectsFromArray:initialSelectedFilters];
	
	[self.showButton setTitle:@"Показать" forState:UIControlStateNormal];
	[self.cancelButton setTitle:@"Отмена" forState:UIControlStateNormal];
	
	self.layout.itemSize = CGSizeMake(80, 80);
	self.layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
	self.layout.minimumLineSpacing = 20;
	self.layout.minimumInteritemSpacing = 20;
	
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	
	[self.collectionView registerNib:
				[UINib nibWithNibName:@"PWRestaurantFilterCell"
				bundle:[NSBundle mainBundle]]forCellWithReuseIdentifier:@"id"];
	self.collectionView.allowsMultipleSelection = YES;
}

- (NSArray<PWFilterHolder *> *)filters
{
	if (nil == _filters)
	{
		PWFilterHolder *allHolder = [PWFilterHolder new];
		allHolder.title = @"Все";
		allHolder.icon = [UIImage imageNamed:@"filterAll"];
		allHolder.filter = kPWRestaurantTypeAll;
		self.allFilterHolder = allHolder;
		
		PWFilterHolder *fastFoodHolder = [PWFilterHolder new];
		fastFoodHolder.title = @"Фаст фуд";
		fastFoodHolder.icon = [UIImage imageNamed:@"filterFastFood"];
		fastFoodHolder.filter = kPWRestaurantTypeFastFood;
		
		PWFilterHolder *cafeHolder = [PWFilterHolder new];
		cafeHolder.title = @"Кафе";
		cafeHolder.icon = [UIImage imageNamed:@"filterCafe"];
		cafeHolder.filter = kPWRestaurantTypeCafe;
		
		PWFilterHolder *sushiHolder = [PWFilterHolder new];
		sushiHolder.title = @"Суши";
		sushiHolder.icon = [UIImage imageNamed:@"filterSushi"];
		sushiHolder.filter = kPWRestaurantTypeSushi;
		
		PWFilterHolder *hookahHolder = [PWFilterHolder new];
		hookahHolder.title = @"Кальян";
		hookahHolder.icon = [UIImage imageNamed:@"filterHookah"];
		hookahHolder.filter = kPWRestaurantTypeHookah;
		
		PWFilterHolder *pizzaHolder = [PWFilterHolder new];
		pizzaHolder.title = @"Пицца";
		pizzaHolder.icon = [UIImage imageNamed:@"filterPizza"];
		pizzaHolder.filter = kPWRestaurantTypePizza;
		
		PWFilterHolder *foodHolder = [PWFilterHolder new];
		foodHolder.title = @"Еда";
		foodHolder.icon = [UIImage imageNamed:@"filterFood"];
		foodHolder.filter = kPWRestaurantTypeFood;
		
		PWFilterHolder *barHolder = [PWFilterHolder new];
		barHolder.title = @"Бар";
		barHolder.icon = [UIImage imageNamed:@"filterBar"];
		barHolder.filter = kPWRestaurantTypeBar;
		
		_filters = @[allHolder, fastFoodHolder, cafeHolder,
					sushiHolder, hookahHolder, pizzaHolder, foodHolder, barHolder];
	}
	
	return _filters;
}

- (IBAction)showAction:(id)sender
{
	if (nil != self.completion)
	{
		PWRestaurantType result = 0;
		for (PWFilterHolder *holder in self.selectedFilters)
		{
			result |= holder.filter;
		}
		
		self.completion(result);
	}
	
	[self back];
}

- (IBAction)cancelAction:(id)sender
{
	[self back];
}

- (void)back
{
	[self.transiter performBackTransition];
}

- (void)setupWithNavigationItem:(UINavigationItem *)item
{
	[self setupBackItemWithTarget:self action:@selector(back)
				navigationItem:item];
	
	UILabel *theTitleLabel = [UILabel new];
	theTitleLabel.text = @"Типы заведений";
	theTitleLabel.font = [UIFont systemFontOfSize:20];
	[theTitleLabel sizeToFit];
	
	item.leftBarButtonItems = @[item.leftBarButtonItem,
				[[UIBarButtonItem alloc] initWithCustomView:theTitleLabel]];
	item.rightBarButtonItem = nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
			numberOfItemsInSection:(NSInteger)section
{
	return self.filters.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
			cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWRestaurantFilterCell *cell = [self.collectionView
				dequeueReusableCellWithReuseIdentifier:@"id" forIndexPath:indexPath];
	PWFilterHolder *holder = self.filters[indexPath.item];
	cell.title = holder.title;
	cell.image = holder.icon;
	if ([self.selectedFilters containsObject:holder])
	{
		[collectionView selectItemAtIndexPath:indexPath animated:NO
					scrollPosition:UICollectionViewScrollPositionNone];
		[cell setSelected:YES];
	}
	else
	{
		[collectionView deselectItemAtIndexPath:indexPath animated:NO];
		[cell setSelected:NO];
	}
	
	return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
			shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWFilterHolder *holder = self.filters[indexPath.item];
	
	return ![self.selectedFilters containsObject:holder];
}

- (BOOL)collectionView:(UICollectionView *)collectionView
			shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
	return 0 != indexPath.item;
}

- (void)collectionView:(UICollectionView *)collectionView
			didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWFilterHolder *holder = self.filters[indexPath.item];
	NSMutableArray *indexPaths = [NSMutableArray new];
	
	if (holder == self.allFilterHolder)
	{
		for (PWFilterHolder *selectedHolder in self.selectedFilters)
		{
			[indexPaths addObject:[NSIndexPath indexPathForItem:
						[self.filters indexOfObject:selectedHolder] inSection:0]];
		}
		
		[indexPaths addObject:[NSIndexPath indexPathForItem:0 inSection:0]];
		
		[self.selectedFilters removeAllObjects];
		[self.selectedFilters addObject:self.allFilterHolder];
	}
	else
	{
		if ([self.selectedFilters containsObject:self.allFilterHolder])
		{
			[self.selectedFilters removeObject:self.allFilterHolder];
			[indexPaths addObject:[NSIndexPath indexPathForItem:0 inSection:0]];
		}
		
		[self.selectedFilters addObject:holder];
		[indexPaths addObject:[NSIndexPath indexPathForItem:
					[self.filters indexOfObject:holder] inSection:0]];
	}
	
	[self.collectionView reloadItemsAtIndexPaths:indexPaths];
}

- (void)collectionView:(UICollectionView *)collectionView
			didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
	PWFilterHolder *holder = self.filters[indexPath.item];
	NSMutableArray *indexPaths = [NSMutableArray new];
	
	[indexPaths addObject:[NSIndexPath indexPathForItem:
				[self.filters indexOfObject:holder] inSection:0]];
	
	[self.selectedFilters removeObject:holder];
	
	if (0 == self.selectedFilters.count)
	{
		[self.selectedFilters addObject:self.allFilterHolder];
		[indexPaths addObject:[NSIndexPath indexPathForItem:0 inSection:0]];
	}
	
	[self.collectionView reloadItemsAtIndexPaths:indexPaths];
}

@end
