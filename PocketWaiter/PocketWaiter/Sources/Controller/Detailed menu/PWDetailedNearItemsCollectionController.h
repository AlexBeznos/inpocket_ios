//
//  PWDetailledNearItemsController.h
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewControllerAdditions.h"

@interface PWDetailedNearItemsCollectionController : UICollectionViewController

- (instancetype)initWithTransiter:(id<IPWTransiter>)transiter;

@property (nonatomic, readonly) NSString *navigationTitle;
@property (nonatomic, weak, readonly) id<IPWTransiter> transiter;

- (void)setContentSize:(CGSize)contentSize;

@end
