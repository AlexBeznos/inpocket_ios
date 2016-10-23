//
//  PWAddToOrderControler.m
//  PocketWaiter
//
//  Created by Www Www on 10/3/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWAddToOrderControler.h"
#import "PWProduct.h"
#import "PWPrice.h"
#import "PWRestaurant.h"

@interface PWAddToOrderControler ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *buttonTitle;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UIImageView *productImage;
@property (strong, nonatomic) IBOutlet UILabel *bonusesLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bonusesImage;

@property (nonatomic, strong) NSString *categoryTitle;
@property (nonatomic, strong) PWProduct *product;
@property (nonatomic, strong) PWRestaurant *restaurant;

@end

@implementation PWAddToOrderControler

@synthesize transiter;

- (instancetype)initWithTitle:(NSString *)name product:(PWProduct *)product restaurant:(PWRestaurant *)restaurant
{
	self = [super init];
	
	if (nil != self)
	{
		self.categoryTitle = name;
		self.product = product;
		self.restaurant = restaurant;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.priceLabel.text = self.product.price.humanReadableValue;
	self.bonusesLabel.text = [NSString stringWithFormat:@"+%li", (unsigned long)self.product.bonusesValue];
	self.productImage.image = self.product.icon;
	self.button.backgroundColor = self.restaurant.color;
	self.titleLabel.text = self.product.name;
	self.bonusesImage.image = [[UIImage imageNamed:@"collectedBonus"]
					imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[self.bonusesImage setTintColor:self.restaurant.color];
	self.descriptionLabel.text = self.product.productDescription;
	self.buttonTitle.text = @"+ Добавить в заказ";
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
	theTitleLabel.text = self.categoryTitle;
	theTitleLabel.font = [UIFont systemFontOfSize:20];
	[theTitleLabel sizeToFit];
	
	item.leftBarButtonItems = @[item.leftBarButtonItem,
				[[UIBarButtonItem alloc] initWithCustomView:theTitleLabel]];
	item.rightBarButtonItems = nil;
}

- (IBAction)addToOrder:(id)sender
{
}

@end
