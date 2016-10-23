//
//  PWMenuTabController.h
//  PocketWaiter
//
//  Created by Www Www on 10/3/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWScrollableViewController.h"
#import "UIViewControllerAdditions.h"

@class PWRestaurant;

@interface PWMenuTabController : PWScrollableViewController

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant
			transiter:(id<IPWTransiter>)transiter defaultMode:(BOOL)defaultMode;

@property (nonatomic) CGFloat contentWidth;

@end
