//
//  PWNearPresentViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWScrollHandlerController.h"

@protocol IPWTransiter;
@class PWNearItemCollectionViewCell;

@interface PWNearItemsViewController : PWScrollHandlerController

@property (nonatomic) CGSize contentSize;
@property (nonatomic, weak, readonly) id<IPWTransiter> transiter;

- (instancetype)initWithScrollHandler:
			(void (^)(CGPoint velocity))aHandler
			transiter:(id<IPWTransiter>)transiter;

- (void)setupCell:(PWNearItemCollectionViewCell *)cell
			forItemAtIndexPath:(NSIndexPath *)indexPath;

@end
