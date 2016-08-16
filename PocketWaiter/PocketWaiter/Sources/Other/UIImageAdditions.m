//
//  UIImageAdditions.m
//  PocketWaiter
//
//  Created by Www Www on 8/17/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "UIImageAdditions.h"
#import <CoreGraphics/CoreGraphics.h>

#define   DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

@implementation UIImage (MarkerDrawwing)

+ (UIImage *)markerImageWithState:(BOOL)selected scheme:(UIColor *)color
			logo:(UIImage *)logo
{
	CGSize size = selected ? CGSizeMake(80, 100) : CGSizeMake(60, 75);
	UIImage *logoImage = [self scaledImage:logo
				withSize:CGSizeMake(size.width, size.width)];
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	[[UIColor clearColor] setFill];
	UIRectFill(CGRectMake(0, 0, size.width, size.height));
	
	UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:
				CGPointMake(size.width / 2, size.width / 2) radius:size.width / 2
				startAngle:DEGREES_TO_RADIANS(45) endAngle:DEGREES_TO_RADIANS(135)
				clockwise:NO];
	
	[path addLineToPoint:CGPointMake(size.width / 2, size.height)];
	[path closePath];
	
	[color setFill];
	[path fill];
	
	path = [UIBezierPath bezierPathWithOvalInRect:
				CGRectMake(4, 4, size.width - 8, size.width - 8)];
	
	[path addLineToPoint:CGPointMake(size.width / 2, size.height)];
	[path closePath];
	
	[path addClip];
	[logoImage drawAtPoint:CGPointZero];
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	return image;
}

+ (UIImage *)scaledImage:(UIImage *)image withSize:(CGSize)size
{
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return resultImage;
}

@end
