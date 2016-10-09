//
//  PWReviewsListViewController.h
//  PocketWaiter
//
//  Created by Www Www on 10/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWReviewsListViewController : UIViewController

- (instancetype)initWithReviews:(NSArray<PWRestaurantReview *> *)reviews;

@property (nonatomic) CGFloat contentWidth;
@property (nonatomic, readonly) CGSize contentSize;

@end
