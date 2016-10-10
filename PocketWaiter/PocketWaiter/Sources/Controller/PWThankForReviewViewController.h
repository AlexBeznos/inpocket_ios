//
//  PWThankForReviewViewController.h
//  PocketWaiter
//
//  Created by Www Www on 10/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWScrollableViewController.h"
#import "UIViewControllerAdditions.h"

@interface PWThankForReviewViewController : PWScrollableViewController

- (instancetype)initWithReview:(PWRestaurantReview *)review transiter:(id<IPWTransiter>)transiter;
@property (nonatomic) CGFloat contentWidth;

@end
