//
//  PWScrollHandlerController.h
//  PocketWaiter
//
//  Created by Www Www on 10/1/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWScrollableViewController.h"

@interface PWScrollHandlerController : PWScrollableViewController

@property (nonatomic, readonly) void (^handler)(CGPoint);
@property (nonatomic, readonly) UIPanGestureRecognizer *panRecognizer;

- (instancetype)initWithScrollHandler:
			(void (^)(CGPoint velocity))aHandler;

@end
