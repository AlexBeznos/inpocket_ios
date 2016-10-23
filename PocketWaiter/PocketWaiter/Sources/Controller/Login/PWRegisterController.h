//
//  PWRegisterController.h
//  PocketWaiter
//
//  Created by Www Www on 9/5/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWScrollableViewController.h"
#import "UIViewControllerAdditions.h"

@interface PWRegisterController : PWScrollableViewController <IPWTransitableController>

- (instancetype)initWithCompletion:(void (^)())completion;

@end
