//
//  PWIntroLayout.m
//  PocketWaiter
//
//  Created by Www Www on 8/6/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWIntroLayout.h"

@implementation PWIntroLayout

- (CGSize)collectionViewContentSize
{
	return CGSizeMake(self.itemSize.width * self.countOfSlides,
				self.itemSize.height);
}

@end
