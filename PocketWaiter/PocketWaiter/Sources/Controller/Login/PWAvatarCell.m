//
//  PWAvatarCell.m
//  PocketWaiter
//
//  Created by Www Www on 10/23/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWAvatarCell.h"
#import "PWImageView.h"

@interface PWAvatarCell ()

@property (strong, nonatomic) IBOutlet PWImageView *avatarView;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *cellView;

@end

@implementation PWAvatarCell

- (IBAction)changeAvatar:(id)sender {
    if (nil != self.handler)
    {
        self.handler();
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(changeAvatar:)];
    [_cellView addGestureRecognizer:tap];
    
}

@end
