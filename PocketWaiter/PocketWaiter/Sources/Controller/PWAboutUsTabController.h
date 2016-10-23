//
//  PWAboutUsTabController.h
//  PocketWaiter
//
//  Created by Www Www on 10/10/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWScrollableViewController.h"
@protocol IPWTransiter;

@interface PWAboutUsTabController : PWScrollableViewController

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant
			transiter:(id<IPWTransiter>)transiter defaultMode:(BOOL)defaultMode;

@property (nonatomic) CGFloat contentWidth;

@end
