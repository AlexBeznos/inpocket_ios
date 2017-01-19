//
//  PWFirstPresentController.m
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWFirstPresentController.h"
#import "PWFirstPresentCell.h"
#import "PWPresentProduct.h"
#import "PWRestaurant.h"
#import "UIColorAdditions.h"

@interface PWFirstPresentController ()

@property (nonatomic, strong) PWPresentProduct *present;
@property (nonatomic, strong) PWRestaurant *restaurant;
@property (copy, nonatomic) void (^getPresentHandler)();

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation PWFirstPresentController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithPresent:(PWPresentProduct *)present restaurant:(PWRestaurant *)restaurant getPresentHandler:(void (^)())handler
{
	UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
	layout.minimumLineSpacing = 20;
	layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
	layout.minimumInteritemSpacing = 0;
	 
	layout.itemSize = CGSizeMake(320, 375);
	layout.scrollDirection = UICollectionViewScrollDirectionVertical;
	self = [super initWithCollectionViewLayout:layout];
	
	if (nil != self)
	{
		self.layout = layout;
		self.present = present;
		self.restaurant = restaurant;
		self.getPresentHandler = handler;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.collectionView registerNib:[UINib nibWithNibName:@"PWFirstPresentCell"
				bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
	self.collectionView.scrollEnabled = NO;
	
	self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.view
				attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
				toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:420];
	self.widthConstraint = [NSLayoutConstraint constraintWithItem:self.view
				attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
				toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1
				constant:320];
	self.collectionView.backgroundColor = [UIColor pwBackgroundColor];
	[self.view addConstraint:self.widthConstraint];
	[self.view addConstraint:self.heightConstraint];
}

- (void)setContentSize:(CGSize)contentSize
{
	self.widthConstraint.constant = contentSize.width;
	self.heightConstraint.constant = contentSize.height;
	self.layout.itemSize = CGSizeMake(contentSize.width - 40, contentSize.height - 20);
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
 {
    PWFirstPresentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.colorScheme = self.restaurant.color;
    cell.descriptionLabel.text = self.present.productDescription;
    cell.presentImageView.image = self.present.icon;
    cell.getPresentHandler = self.getPresentHandler;
	 
    return cell;
}

@end
