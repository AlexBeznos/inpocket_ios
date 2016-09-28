//
//  PWIndicator.h
//  PocketWaiter
//
//  Created by Www Www on 7/30/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

////////////////////////////////////////////////////////////////////////////////
#import <UIKit/UIKit.h>

////////////////////////////////////////////////////////////////////////////////
@interface PWIndicator : UIView

@property (nonatomic) NSUInteger itemsCount;
@property (nonatomic) NSUInteger selectedItemIndex;
@property (nonatomic, strong) UIColor *colorSchema;

@end
