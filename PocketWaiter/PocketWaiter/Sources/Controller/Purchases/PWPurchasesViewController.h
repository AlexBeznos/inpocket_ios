//
//  PWPurchasesViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWActivityIndicatorOwner.h"
#import "UIViewControllerAdditions.h"

@class PWUser;

@interface PWPurchasesViewController : PWActivityIndicatorOwner
			<IPWTransitableController>

- (instancetype)initWithUser:(PWUser *)user restaurants:(NSArray *)restaurants;

@end
