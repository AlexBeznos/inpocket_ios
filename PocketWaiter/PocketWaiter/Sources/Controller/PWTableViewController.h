//
//  PWScrollableViewController.h
//  PocketWaiter
//
//  Created by Www Www on 10/1/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWActivityIndicator;

@interface PWTableViewController : UITableViewController

@property (nonatomic, readonly) PWActivityIndicator *activity;

- (void)startActivity;
- (void)startActivityInView:(UIView *)view;
- (void)startActivityWithTopOffset:(CGFloat)offset;
- (void)stopActivity;

- (void)resumeActivity;
- (void)suspendActivity;

- (void)showNoInternetDialog;

@end
