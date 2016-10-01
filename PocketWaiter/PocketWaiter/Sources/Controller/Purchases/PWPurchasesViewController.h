//
//  PWPurchasesViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWScrollableViewController.h"
#import "UIViewControllerAdditions.h"

@class PWUser;

@interface PWPurchasesViewController : PWScrollableViewController
			<IPWTransitableController>

- (instancetype)initWithUser:(PWUser *)user restaurants:(NSArray *)restaurants;

@end
