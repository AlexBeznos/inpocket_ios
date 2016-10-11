//
//  PWPhotosController.h
//  PocketWaiter
//
//  Created by Www Www on 10/11/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewControllerAdditions.h"

@interface PWPhotosController : UICollectionViewController <IPWTransitableController>

- (instancetype)initWithAboutInfo:(PWRestaurantAboutInfo *)info;

@property (nonatomic) CGFloat contentWidth;

@end
