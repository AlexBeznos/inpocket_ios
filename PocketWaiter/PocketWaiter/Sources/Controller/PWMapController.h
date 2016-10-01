//
//  PWMapController.h
//  PocketWaiter
//
//  Created by Www Www on 8/14/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWScrollableViewController.h"
#import "UIViewControllerAdditions.h"

@interface PWMapController : PWScrollableViewController

@property (nonatomic, weak, readonly) id<IPWTransiter> transiter;

- (instancetype)initWithTransiter:(id<IPWTransiter>)transiter;

- (void)setContentSize:(CGSize)contentSize;

@end
