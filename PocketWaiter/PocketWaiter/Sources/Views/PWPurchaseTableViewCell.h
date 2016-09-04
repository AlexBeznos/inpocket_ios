//
//  PWPurchaseTableViewCell.h
//  PocketWaiter
//
//  Created by Www Www on 9/3/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWEnums.h"

@interface PWPurchaseTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) NSUInteger bonusesCount;
@property (nonatomic, strong) NSString *cost;

@end
