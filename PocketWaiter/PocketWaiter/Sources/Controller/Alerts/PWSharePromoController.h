//
//  PWSharePromoController.h
//  PocketWaiter
//
//  Created by Www Www on 9/4/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWModalController.h"

@interface PWSharePromoController : UIViewController <IPWModalContentController>

- (instancetype)initWithPromo:(NSString *)promo
			completion:(void (^)(BOOL))completion;

@end
