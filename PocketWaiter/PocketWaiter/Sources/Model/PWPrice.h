//
//  PWPrice.h
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWModelObject.h"
#import "PWEnums.h"

@interface PWPrice : PWModelObject

- (instancetype)initWithValue:(CGFloat)value currency:(PWPriceCurrency)currency;

@property (nonatomic, readonly) PWPriceCurrency currency;
@property (nonatomic, readonly) CGFloat value;
@property (nonatomic, readonly) NSString *humanReadableValue;

@end
