//
//  PWTapper.h
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWTapper : UIView

@property (nonatomic, strong) NSString *firstValue;
@property (nonatomic, strong) NSString *secondValue;

@property (nonatomic, readonly) NSUInteger selectedTapIndex;

@property (nonatomic, copy) void (^tapHandler)(NSUInteger);

@end
