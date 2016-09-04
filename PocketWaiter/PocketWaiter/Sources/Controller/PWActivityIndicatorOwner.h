//
//  PWActivityIndicatorOwner.h
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWActivityIndicator;

@interface PWActivityIndicatorOwner : UIViewController

@property (nonatomic, readonly) PWActivityIndicator *activity;

- (void)startActivity;
- (void)startActivityWithTopOffset:(CGFloat)offset;
- (void)stopActivity;

- (void)startAsyncActivity;
- (void)stopAsyncActivity;
- (void)restartAsyncActivity;

- (void)showNoInternetDialog;

@end
