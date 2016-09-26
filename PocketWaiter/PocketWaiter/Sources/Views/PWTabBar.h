//
//  PWTabBar.h
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWTabBarItem : NSObject

- (instancetype)initWithTitle:(NSString *)title handler:(void (^)())handler;

@end

@interface PWTabBar : UIView

- (void)addItem:(PWTabBarItem *)item;
- (void)removeItemAtIndex:(NSUInteger)index;

@property (nonatomic) UIColor *colorSchema;
@property (nonatomic) NSUInteger selectedIndex;

@end
