//
//  PWNearRestaurantCollectionViewCell.h
//  PocketWaiter
//
//  Created by Www Www on 8/12/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWImageView;

@interface PWNearRestaurantCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSString *place;
@property (readonly, nonatomic) PWImageView *imageView;

@end
