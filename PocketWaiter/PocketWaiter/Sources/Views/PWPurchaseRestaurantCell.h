//
//  PWPurchaseRestaurantCell.h
//  PocketWaiter
//
//  Created by Www Www on 8/24/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWPurchaseRestaurantCell : UICollectionViewCell

@property (nonatomic) UIColor *color;
@property (nonatomic) UIImage *image;

@property (nonatomic) NSUInteger bonusesCount;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *descriptionText;

@end
