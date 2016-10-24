//
//  PWProduct.h
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWOwnedObject.h"
#import "PWEnums.h"

@class PWPrice;

@interface PWProduct : PWOwnedObject

@property (nonatomic, readonly) NSString *category;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *productDescription;
@property (nonatomic, readonly) UIImage *icon;
@property (nonatomic, readonly) PWPrice *price;
@property (nonatomic, readonly) NSUInteger bonusesValue;
@property (nonatomic, readonly) PWProductType type;

@property (nonatomic, readonly) NSString *iconPath;
@property (nonatomic, strong) NSString *downloadedIconPath;

@end
