//
//  PWDetailesItemsViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "UIViewControllerAdditions.h"
#import "PWActivityIndicatorOwner.h"

@interface PWDetailesItemsViewController : PWActivityIndicatorOwner
			<IPWTransitableController>

- (instancetype)initWithListModeOnly:(BOOL)aListOnly;

@end
