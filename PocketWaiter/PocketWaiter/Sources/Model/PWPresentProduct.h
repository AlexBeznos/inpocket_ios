//
//  PWPresentProduct.h
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWProduct.h"

@interface PWPresentProduct : PWProduct

+ (instancetype)firstPresentFromSourcePresent:(PWPresentProduct *)present;
@property (nonatomic, readonly) NSUInteger bonusesPrice;

@end
