//
//  PWReviewController.h
//  PocketWaiter
//
//  Created by Www Www on 10/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWReviewController : UIViewController

- (instancetype)initWithReview:(PWRestaurantReview *)review;

@property (nonatomic) CGFloat contentWidth;
@property (nonatomic, readonly) CGSize contentSize;

@end
