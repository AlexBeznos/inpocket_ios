//
//  UIImageAdditions.h
//  PocketWaiter
//
//  Created by Www Www on 8/17/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MarkerDrawwing)

+ (UIImage *)markerImageWithState:(BOOL)selected scheme:(UIColor *)color
			logo:(UIImage *)logo;

@end
