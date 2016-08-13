//
//  PWContentSource.h
//  PocketWaiter
//
//  Created by Www Www on 8/6/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PWContentTransitionHandler)();

@protocol IPWContentTransitionControler <NSObject>

- (instancetype)initWithTransitionHandler:(PWContentTransitionHandler)aHandler
			forwardTransitionHandler:(PWContentTransitionHandler)aFwdHandler;
- (void)resetTransition;

@end

@interface PWContentSource : NSObject

- (instancetype)initWithTitle:(NSString *)title details:(NSString *)details
			icon:(UIImage *)icon contentViewController:
			(UIViewController<IPWContentTransitionControler> *)controller;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *details;
@property (nonatomic, readonly) UIImage *icon;
@property (nonatomic, readonly)
			UIViewController<IPWContentTransitionControler> *contentViewController;

@end
