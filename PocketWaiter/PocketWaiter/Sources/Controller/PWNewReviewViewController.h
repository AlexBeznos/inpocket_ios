//
//  PWNewReviewViewController.h
//  PocketWaiter
//
//  Created by Www Www on 10/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewControllerAdditions.h"
#import "PWScrollableViewController.h"

typedef NS_ENUM(NSUInteger, PWReviewType)
{
	kPWReviewTypeComment,
	kPWReviewTypeShareToFriend,
};

@interface PWNewReviewViewController : PWScrollableViewController <IPWTransitableController>

- (instancetype)initWithType:(PWReviewType)type;

@end
