//
//  PWBestOfDayProductCell.m
//  PocketWaiter
//
//  Created by Www Www on 10/3/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWBestOfDayProductCell.h"

@interface PWBestOfDayProductCell ()

@property (strong, nonatomic) IBOutlet UILabel *bonusesLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bonusesImage;
@property (strong, nonatomic) IBOutlet UILabel *buttonTitle;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *productImageView;

@end

@implementation PWBestOfDayProductCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	[self.button addTarget:self action:@selector(addPresentToOrder:)
				forControlEvents:UIControlEventTouchUpInside];
}

- (void)addPresentToOrder:(UIButton *)sender
{
	if (nil != self.addToOrderHandler)
	{
		self.addToOrderHandler();
	}
}


@end
