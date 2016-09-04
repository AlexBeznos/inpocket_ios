//
//  PWMapController.h
//  PocketWaiter
//
//  Created by Www Www on 8/14/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWActivityIndicatorOwner.h"
#import "UIViewControllerAdditions.h"

@interface PWMapController : PWActivityIndicatorOwner

@property (nonatomic, weak, readonly) id<IPWTransiter> transiter;

- (instancetype)initWithTransiter:(id<IPWTransiter>)transiter;

- (void)setContentSize:(CGSize)contentSize;

@end
