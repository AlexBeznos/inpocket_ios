//
//  PWProductCell.m
//  PocketWaiter
//
//  Created by Www Www on 10/1/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWProductCell.h"
#import "PWDropShadowView.h"

@interface PWProductCell ()

@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) IBOutlet UIButton *getButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *bonusesLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bonusesImageView;
@property (strong, nonatomic) IBOutlet PWDropShadowView *shadowView;
@property (strong, nonatomic) IBOutlet UILabel *addToOrderLabel;

@end

@implementation PWProductCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	[self.getButton addTarget:self action:@selector(addPresentToOrder:)
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
