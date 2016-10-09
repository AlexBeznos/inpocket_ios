//
//  PWNoAccesViewController.h
//  PocketWaiter
//
//  Created by Www Www on 10/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PWUtilType)
{
	kPWUtilTypeCamera,
	kPWUtilTypePhotos
};

@interface PWNoAccesViewController : UIViewController

- (instancetype)initWithType:(PWUtilType)type;

- (void)showWithCompletion:(void (^)())aCompletion;
- (void)hideWithCompletion:(void (^)())aCompletion;

@end
