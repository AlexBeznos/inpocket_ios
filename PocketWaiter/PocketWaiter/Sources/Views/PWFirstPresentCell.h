//
//  PWFirstPresentCell.h
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWFirstPresentCell : UICollectionViewCell

@property (nonatomic) UIColor *colorScheme;
@property (strong, readonly) UILabel *descriptionLabel;
@property (strong, readonly) UIImageView *presentImageView;

@property (copy, nonatomic) void (^getPresentHandler)();

@end
