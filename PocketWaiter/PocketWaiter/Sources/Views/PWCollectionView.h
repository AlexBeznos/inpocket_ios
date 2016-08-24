//
//  PWCollectionView.h
//  PocketWaiter
//
//  Created by Www Www on 8/24/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCollectionView : UICollectionView

@property (nonatomic, copy) void (^contentOffsetObserver)(CGPoint);

@end
