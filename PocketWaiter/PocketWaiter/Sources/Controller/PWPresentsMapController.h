//
//  PWPresentsMapController.h
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWMapController.h"

@class PWPresentProduct;

@interface PWPresentsMapController : PWMapController

- (instancetype)initWithPresents:(NSArray<PWPresentProduct *> *)presents
			selectedPresent:(PWPresentProduct *)present
			transiter:(id<IPWTransiter>)transiter;

@end
