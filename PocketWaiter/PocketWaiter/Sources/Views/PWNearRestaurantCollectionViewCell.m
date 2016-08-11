//
//  PWNearRestaurantCollectionViewCell.m
//  PocketWaiter
//
//  Created by Www Www on 8/12/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWNearRestaurantCollectionViewCell.h"
#import "UIColorAdditions.h"

@interface PWNearRestaurantCollectionViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;

@end

@implementation PWNearRestaurantCollectionViewCell

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

- (void)setImage:(UIImage *)image
{
	self.imageView.image = image;
}

@end
