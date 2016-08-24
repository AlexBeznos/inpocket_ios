//
//  PWModalController.h
//  PocketWaiter
//
//  Created by Www Www on 8/20/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPWModalContentController <NSObject>

@property (nonatomic) CGSize contentSize;

@end

@interface PWModalController : UIViewController

- (instancetype)initWithContentController:
			(UIViewController<IPWModalContentController> *)controller autoDismiss:(BOOL)autodismiss;

- (void)showWithCompletion:(void (^)())aCompletion;
- (void)hideWithCompletion:(void (^)())aCompletion;

@end
