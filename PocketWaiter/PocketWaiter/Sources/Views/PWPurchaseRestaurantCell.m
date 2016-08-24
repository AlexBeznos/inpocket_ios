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

@end

@implementation PWPurchaseRestaurantCell

- (void)setColor:(UIColor *)color
{
	self.colorView.backgroundColor = color;
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

@end
