//
//  PWReviewsTabController.h
//  PocketWaiter
//
//  Created by Www Www on 10/8/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWScrollableViewController.h"

@class PWRestaurant;
@protocol IPWTransiter;

@interface PWReviewsTabController : PWScrollableViewController

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant isActive:(BOOL)isActive
			transiter:(id<IPWTransiter>)transiter;

@property (nonatomic) CGFloat contentWidth;

@end
