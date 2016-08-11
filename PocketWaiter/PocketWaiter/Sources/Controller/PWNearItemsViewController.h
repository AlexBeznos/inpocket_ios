//
//  PWNearPresentViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWNearItemCollectionViewCell;

@interface PWNearItemsViewController : UIViewController

@property (nonatomic) CGSize contentSize;

- (instancetype)initWithScrollHandler:
			(void (^)(CGPoint velocity))aHandler;

- (void)setupCell:(PWNearItemCollectionViewCell *)cell
			forItemAtIndexPath:(NSIndexPath *)indexPath;

@end
