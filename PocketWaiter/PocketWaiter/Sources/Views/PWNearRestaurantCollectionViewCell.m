//
//  PWNearRestaurantCollectionViewCell.m
//  PocketWaiter
//
//  Created by Www Www on 8/12/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWNearRestaurantCollectionViewCell.h"
#import "UIColorAdditions.h"
#import "PWDropShadowView.h"
#import "PWImageView.h"

@interface PWNearRestaurantCollectionViewCell ()

@property (strong, nonatomic) IBOutlet PWImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;
@property (strong, nonatomic) IBOutlet PWDropShadowView *shadowView;

@end

@implementation PWNearRestaurantCollectionViewCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.shadowView.shadowOffset = CGSizeMake(3, 3);
	self.shadowView.shadowOpacity = 0.3;
}

- (void)setTitle:(NSString *)title
{
	self.titleLabel.text = title;
}

- (void)setDescriptionText:(NSString *)descriptionText
{
	self.descriptionLabel.text = descriptionText;
}

- (void)setPlace:(NSString *)place
{
	self.placeLabel.text = place;
}

@end
