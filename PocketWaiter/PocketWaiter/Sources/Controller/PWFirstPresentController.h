//
//  PWFirstPresentController.h
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWPresentProduct;
@class PWRestaurant;

@interface PWFirstPresentController : UICollectionViewController

- (instancetype)initWithPresent:(PWPresentProduct *)present restaurant:(PWRestaurant *)restaurant getPresentHandler:(void (^)())handler;

@property (nonatomic) CGSize contentSize;

@end
