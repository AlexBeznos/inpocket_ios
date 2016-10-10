//
//  PWMoreBonusesViewController.h
//  PocketWaiter
//
//  Created by Www Www on 10/2/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWRestaurant;
@protocol IPWTransiter;

@interface PWMoreBonusesViewController : UIViewController

- (instancetype)initWithRestaurant:(PWRestaurant *) restaurant
			shareEnabled:(BOOL)shareEnabled
			shareBonuses:(NSUInteger)shareBonuses
			commentEnabled:(BOOL)commentEnabled
			commentBonuses:(NSUInteger)commentBonuses
			transiter:(id<IPWTransiter>)transiter;

@property (nonatomic) CGSize contentSize;

@end
