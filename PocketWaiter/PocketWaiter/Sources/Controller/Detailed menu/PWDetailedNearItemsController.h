//
//  PWDetailledNearItemsController.h
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewControllerAdditions.h"

@interface PWDetailedNearItemsController : UICollectionViewController
			<IPWTransitableController>

@property (nonatomic, readonly) NSString *navigationTitle;

- (void)setContentSize:(CGSize)contentSize;

@end
