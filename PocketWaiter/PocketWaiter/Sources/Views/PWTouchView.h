//
//  PWTouchView.h
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWTouchView : UIView

- (instancetype)initWithTouchHandler:(void (^)())aHandler;

@end
