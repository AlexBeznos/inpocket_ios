//
//  PWIntroFirstPageCell.h
//  PocketWaiter
//
//  Created by Www Www on 8/6/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWIntroFirstPageCell : UICollectionViewCell

@property (nonatomic) CGFloat aspectRatio;

@end

@interface PWIntroSecondPageCell : UICollectionViewCell

@property (nonatomic) CGFloat aspectRatio;

@end

@interface PWIntroThirdPageCell : UICollectionViewCell

@property (nonatomic) CGFloat aspectRatio;
@property (nonatomic, copy) void (^promoHandler)();

@end
