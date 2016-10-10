//
//  PWShareCommentViewController.h
//  PocketWaiter
//
//  Created by Www Www on 10/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWScrollableViewController.h"

@interface PWShareCommentViewController : PWScrollableViewController

- (instancetype)initWithReview:(PWRestaurantReview *)review;

@property (nonatomic) CGFloat contentWidth;
@property (nonatomic, readonly) CGSize contentSize;

@end
