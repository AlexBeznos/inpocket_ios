//
//  PWEnterPromoViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/6/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWEnterPromoViewController : UIViewController

- (void)showWithCompletion:(void (^)())aCompletion;
- (void)hideWithCompletion:(void (^)())aCompletion;

@end
