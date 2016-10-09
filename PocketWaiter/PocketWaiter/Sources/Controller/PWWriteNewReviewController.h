//
//  PWWriteNewReviewController.h
//  PocketWaiter
//
//  Created by Www Www on 10/8/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWWriteNewReviewController : UIViewController

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant newReviewHandler:(void (^)())handler;

@property (nonatomic) CGSize contentSize;

@end
