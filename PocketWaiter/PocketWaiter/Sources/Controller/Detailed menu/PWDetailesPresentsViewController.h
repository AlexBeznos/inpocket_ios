//
//  PWDetailesPresentsViewController.h
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWDetailesItemsViewController.h"

@class PWPresentProduct;

@interface PWDetailesPresentsViewController : PWDetailesItemsViewController

- (instancetype)initWithPresents:(NSArray<PWPresentProduct *> *)presents;

@end
