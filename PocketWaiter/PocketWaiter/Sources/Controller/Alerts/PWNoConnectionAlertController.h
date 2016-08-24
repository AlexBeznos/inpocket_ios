//
//  PWNoInternetAlertController.h
//  PocketWaiter
//
//  Created by Www Www on 8/21/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PWModalController.h"

typedef NS_ENUM(NSUInteger, PWConnectionType)
{
	kPWConnectionTypeInternet,
	kPWConnectionTypeBluetooth,
	kPWConnectionTypeLocation
};

@interface PWNoConnectionAlertController : UIViewController <IPWModalContentController>

- (instancetype)initWithType:(PWConnectionType)type retryAction:(void (^)())action;

@end
