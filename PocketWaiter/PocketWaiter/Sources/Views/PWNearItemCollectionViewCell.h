//
//  PWNearPresentCollectionViewCell.h
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWNearItemCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSString *buttonTitle;
@property (strong, nonatomic) NSString *descriptionTitle;
@property (strong, nonatomic) NSString *placeName;
@property (strong, nonatomic) NSString *placeDistance;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIColor *colorScheme;
@property (nonatomic) BOOL deleteDescriptionView;

@property (nonatomic, copy) void (^moreHandler)();

@end
