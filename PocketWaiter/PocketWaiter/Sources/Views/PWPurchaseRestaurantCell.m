//
//  PWPurchaseRestaurantCell.m
//  PocketWaiter
//
//  Created by Www Www on 8/24/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWPurchaseRestaurantCell.h"

@interface PWPurchaseRestaurantCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *colorView;
@property (strong, nonatomic) IBOutlet UILabel *bonusesCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *bonusesLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation PWPurchaseRestaurantCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.bonusesLabel.text = @"Бонусов";
}

- (void)setColor:(UIColor *)color
{
	CGFloat red;
	CGFloat green;
	CGFloat blue;
	[color getRed:&red green:&green blue:&blue alpha:NULL];
	self.colorView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.4];
}

- (UIColor *)color
{
	return self.colorView.backgroundColor;
}

- (void)setImage:(UIImage *)image
{
	self.imageView.image = image;
}

- (UIImage *)image
{
	return self.imageView.image;
}

- (NSString *)name
{
	return self.nameLabel.text;
}

- (void)setName:(NSString *)name
{
	self.nameLabel.text = name;
}

- (void)setBonusesCount:(NSUInteger)bonusesCount
{
	self.bonusesCountLabel.text = [NSString stringWithFormat:@"%li", (unsigned long)bonusesCount];
}

- (NSUInteger)bonusesCount
{
	return [self.bonusesCountLabel.text integerValue];
}

- (void)setDescriptionText:(NSString *)descriptionText
{
	self.descriptionLabel.text = descriptionText;
}

- (NSString *)descriptionText
{
	return self.descriptionLabel.text;
}

@end
