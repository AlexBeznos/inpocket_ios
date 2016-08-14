//
//  PWNearPresentViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IPWTransiter;
@class PWNearItemCollectionViewCell;

@interface PWNearItemsViewController : UIViewController

@property (nonatomic) CGSize contentSize;

- (instancetype)initWithScrollHandler:
			(void (^)(CGPoint velocity))aHandler
			transiter:(id<IPWTransiter>)transiter;

- (void)setupCell:(PWNearItemCollectionViewCell *)cell
			forItemAtIndexPath:(NSIndexPath *)indexPath;

@end
