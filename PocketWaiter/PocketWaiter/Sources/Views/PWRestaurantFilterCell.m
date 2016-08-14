//
//  PWRestaurantFilterCell.m
//  PocketWaiter
//
//  Created by Www Www on 8/14/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRestaurantFilterCell.h"
#import "PWDropShadowView.h"

@interface PWRestaurantFilterCell ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet PWDropShadowView *shadowView;

@end

@implementation PWRestaurantFilterCell

- (void)setTitle:(NSString *)title
{
	self.titleLabel.text = title;
}

- (NSString *)title
{
	return self.titleLabel.text;
}

- (void)setImage:(UIImage *)image
{
	self.imageView.image = image;
}

- (UIImage *)image
{
	return self.imageView.image;
}

- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
	
	self.shadowView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1
				alpha:selected ? 0.5 : 1];
}

@end
