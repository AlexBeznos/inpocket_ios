//
//  PWSlidesLayout.m
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWSlidesLayout.h"

@implementation PWSlidesLayout

- (CGSize)collectionViewContentSize
{
	return CGSizeMake((self.minimumLineSpacing + self.itemSize.width) *
				self.countOfSlides - self.minimumLineSpacing + 2 * self.sectionInset.left,
				self.itemSize.height);
}

@end
