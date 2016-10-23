//
//  PWRootMenuTableViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/6/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWRestaurant;
@protocol IPWContentTransitionControler;

@interface PWRootMenuTableViewController : UIViewController

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant;
- (void)presentRestaurant:(PWRestaurant *)restaurant;
@property (nonatomic, strong) PWRestaurant *restaurant;

@end
