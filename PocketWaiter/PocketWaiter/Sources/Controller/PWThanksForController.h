//
//  PWThanksForOrderHolderController.h
//  PocketWaiter
//
//  Created by Www Www on 10/2/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWRestaurant;
@class PWPurchase;

typedef NS_ENUM(NSUInteger, PWItemType)
{
	kPWItemTypePresent,
	kPWItemTypePurchase,
	kPWItemTypeComment
};

@interface PWThanksForController : UIViewController

- (instancetype)initWithType:(PWItemType)type scheme:(UIColor *)color
			bonusesCount:(NSUInteger)count backHandler:(void (^)())handler;
@property (nonatomic) CGSize contentSize;

@end
