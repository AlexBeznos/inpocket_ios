//
//  UIColorAdditions.m
//  PocketWaiter
//
//  Created by Www Www on 8/6/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "UIColorAdditions.h"

@implementation UIColor (pwAdditions)

+ (UIColor *)pwColorWithAlpha:(CGFloat)alpha
{
	return [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:alpha];
}

+ (UIColor *)pwBackgroundColor
{
	UIImage *bgImage = [[UIImage imageNamed:@"bgPattern"]
				resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
	
	return [UIColor colorWithPatternImage:bgImage];
}

@end
