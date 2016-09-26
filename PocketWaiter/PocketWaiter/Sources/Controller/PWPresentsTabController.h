//
//  PWPresentsTabController.h
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWActivityIndicatorOwner.h"

@class PWRestaurant;

@interface PWPresentsTabController : PWActivityIndicatorOwner

- (instancetype)initWithRestaurant:(PWRestaurant *)restaurant;

@property (nonatomic) CGSize contentSize;

@end
