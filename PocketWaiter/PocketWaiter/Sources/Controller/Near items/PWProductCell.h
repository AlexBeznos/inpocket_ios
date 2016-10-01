//
//  PWProductCell.h
//  PocketWaiter
//
//  Created by Www Www on 10/1/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWDropShadowView;

@interface PWProductCell : UICollectionViewCell

@property (readonly, nonatomic) UIImageView *productImageView;
@property (readonly, nonatomic) UIButton *getButton;
@property (readonly, nonatomic) UILabel *nameLabel;
@property (readonly, nonatomic) UILabel *priceLabel;
@property (readonly, nonatomic) UILabel *bonusesLabel;
@property (readonly, nonatomic) UIImageView *bonusesImageView;
@property (readonly, nonatomic) PWDropShadowView *shadowView;
@property (readonly, nonatomic) UILabel *addToOrderLabel;

@property (copy, nonatomic) void (^addToOrderHandler)();

@end
