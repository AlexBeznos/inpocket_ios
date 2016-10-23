//
//  PWAvatarCell.h
//  PocketWaiter
//
//  Created by Www Www on 10/23/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PWImageView;

@interface PWAvatarCell : UITableViewCell

@property (readonly, nonatomic) PWImageView *avatarView;
@property (readonly, nonatomic) UILabel *title;

@property (nonatomic, copy) void (^handler)();

@end
