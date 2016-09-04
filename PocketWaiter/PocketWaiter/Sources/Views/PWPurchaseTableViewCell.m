//
//  PWPurchaseTableViewCell.m
//  PocketWaiter
//
//  Created by Www Www on 9/3/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWPurchaseTableViewCell.h"
#import "PWDropShadowView.h"

@interface PWPurchaseTableViewCell ()

@property (strong, nonatomic) IBOutlet PWDropShadowView *shadowView;
@property (strong, nonatomic) IBOutlet UIImageView *logoView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *bonusLabel;
@property (strong, nonatomic) IBOutlet UILabel *bonusCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *costLabel;

@end

@implementation PWPurchaseTableViewCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.shadowView.shadowOffset = CGSizeMake(5, 5);
	self.bonusLabel.text = @"бонусов";
}

- (UIImage *)image
{
	return self.logoView.image;
}

- (void)setImage:(UIImage *)image
{
	self.logoView.image = image;
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
	self.bonusCountLabel.text = [NSString stringWithFormat:@"+%li", (unsigned long)bonusesCount];
}

- (NSUInteger)bonusesCount
{
	return [[self.bonusCountLabel.text substringFromIndex:1] integerValue];
}

- (void)setCost:(NSString *)cost
{
	if (_cost != cost)
	{
		_cost = cost;
		self.costLabel.text = cost;
	}
}

@end
