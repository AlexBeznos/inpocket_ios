//
//  PWMainAboutViewController.h
//  PocketWaiter
//
//  Created by Www Www on 10/10/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "UIViewControllerAdditions.h"

@interface PWMainAboutViewController : UIViewController

- (instancetype)initWithRestaurantInfo:(PWRestaurantAboutInfo *)about transiter:(id<IPWTransiter>)transiter;

@property (nonatomic) CGFloat contentWidth;
- (CGSize)contentSize;

@end
