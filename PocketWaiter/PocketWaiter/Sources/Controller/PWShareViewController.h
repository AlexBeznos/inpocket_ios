//
//  PWShareViewController.h
//  PocketWaiter
//
//  Created by Www Www on 9/4/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "UIViewControllerAdditions.h"

@class PWRestaurantShare;

@interface PWShareViewController : UIViewController <IPWTransitableController>

- (instancetype)initWithShare:(PWRestaurantShare *)share;

@end
