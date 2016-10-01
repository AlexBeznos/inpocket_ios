//
//  PWScrollHandlerController.m
//  PocketWaiter
//
//  Created by Www Www on 10/1/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWScrollHandlerController.h"

@interface PWScrollHandlerController () <UIGestureRecognizerDelegate>

@property (nonatomic, copy) void (^handler)(CGPoint);
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@end

@implementation PWScrollHandlerController

- (instancetype)initWithScrollHandler:
			(void (^)(CGPoint velocity))aHandler
{
	self = [super init];
	
	if (nil != self)
	{
		self.handler = aHandler;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self setupGestures];
}

- (UIView *)scrollHandlerView
{
	return self.view;
}

- (void)setupGestures
{
	self.panRecognizer = [[UIPanGestureRecognizer alloc]
				initWithTarget:self action:@selector(panAction:)];
	self.panRecognizer.delegate = self;
	[self.scrollHandlerView addGestureRecognizer:self.panRecognizer];
}

- (void)panAction:(UIPanGestureRecognizer *)sender
{
	if (nil != self.handler && sender.state == UIGestureRecognizerStateEnded)
	{
		self.handler([sender velocityInView:self.scrollHandlerView]);
	}
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
			shouldRecognizeSimultaneouslyWithGestureRecognizer:
			(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	if ([gestureRecognizer isEqual:self.panRecognizer])
	{
		if (gestureRecognizer.numberOfTouches > 0)
		{
			CGPoint translation = [self.panRecognizer velocityInView:self.scrollHandlerView];
			return fabs(translation.y) > fabs(translation.x);
		}
		else
		{
			return NO;
		}
	}
	return YES;
}

@end
