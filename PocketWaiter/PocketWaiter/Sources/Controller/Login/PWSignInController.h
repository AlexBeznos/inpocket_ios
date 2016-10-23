//
//  PWRegisterController.h
//  PocketWaiter
//
//  Created by Www Www on 9/5/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWScrollableViewController.h"

@protocol IPWTransiter;

@interface PWSignInController : PWScrollableViewController

- (instancetype)initWithCompletion:(void (^)(PWUser *user))completion
			transiter:(id<IPWTransiter>)transiter;

@end
