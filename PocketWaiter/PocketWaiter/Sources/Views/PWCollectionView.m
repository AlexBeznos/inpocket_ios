//
//  PWCollectionView.m
//  PocketWaiter
//
//  Created by Www Www on 8/24/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWCollectionView.h"

@implementation PWCollectionView

- (void)setContentOffset:(CGPoint)contentOffset
{
	[super setContentOffset:contentOffset];
	
	if (nil != self.contentOffsetObserver)
	{
		self.contentOffsetObserver(contentOffset);
	}
}

@end
