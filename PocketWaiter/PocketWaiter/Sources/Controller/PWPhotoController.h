//
//  PWPhotoController.h
//  PocketWaiter
//
//  Created by Www Www on 10/11/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewControllerAdditions.h"

@interface PWPhotoController : UIViewController <IPWTransitableController>

- (instancetype)initWithImage:(UIImage *)photo index:(NSUInteger)index count:(NSUInteger)count;

@end
