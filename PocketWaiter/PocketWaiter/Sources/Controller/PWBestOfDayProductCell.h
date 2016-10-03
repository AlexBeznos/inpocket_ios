//
//  PWBestOfDayProductCell.h
//  PocketWaiter
//
//  Created by Www Www on 10/3/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWBestOfDayProductCell : UICollectionViewCell

@property (readonly, nonatomic) UILabel *bonusesLabel;
@property (readonly, nonatomic) UIImageView *bonusesImage;
@property (readonly, nonatomic) UILabel *buttonTitle;
@property (readonly, nonatomic) UIButton *button;
@property (readonly, nonatomic) UILabel *nameLabel;
@property (readonly, nonatomic) UILabel *priceLabel;
@property (readonly, nonatomic) UILabel *descriptionLabel;
@property (readonly, nonatomic) UIImageView *productImageView;

@property (copy, nonatomic) void (^addToOrderHandler)();

@end
