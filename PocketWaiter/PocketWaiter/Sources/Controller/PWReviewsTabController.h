//
//  PWReviewsTabController.h
//  PocketWaiter
//
//  Created by Www Www on 10/8/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWScrollableViewController.h"

@class PWRestaurant;

@interface PWReviewsTabController : PWScrollableViewController

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant isActive:(BOOL)isActive;

@property (nonatomic) CGFloat contentWidth;

@end
