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

@end

@implementation PWAvatarCell

- (IBAction)changeAvatar:(id)sender
{
	if (nil != self.handler)
	{
		self.handler();
	}
}

@end
