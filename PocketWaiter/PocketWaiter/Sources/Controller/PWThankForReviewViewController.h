//
//  PWThankForReviewViewController.h
//  PocketWaiter
//
//  Created by Www Www on 10/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWScrollableViewController.h"
#import "UIViewControllerAdditions.h"

@interface PWThankForReviewViewController : PWScrollableViewController

- (instancetype)initWithTransiter:(id<IPWTransiter>)transiter;
@property (nonatomic) CGFloat contentWidth;

@end
