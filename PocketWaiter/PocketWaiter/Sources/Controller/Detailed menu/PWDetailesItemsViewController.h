//
//  PWDetailesItemsViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "UIViewControllerAdditions.h"
#import "PWScrollableViewController.h"

@interface PWDetailesItemsViewController : PWScrollableViewController
			<IPWTransitableController>

- (instancetype)initWithListModeOnly:(BOOL)aListOnly;

@end
