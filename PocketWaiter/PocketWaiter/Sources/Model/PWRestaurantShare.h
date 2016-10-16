//
//  PWRestaurantShare.h
//  PocketWaiter
//
//  Created by Www Www on 7/30/16.
//  Copyright © 2016 Www Www. All rights reserved.
//

#import "PWModelObject.h"
#import "IPWRestaurant.h"

@interface PWRestaurantShare : PWModelObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *shareDescription;
@property (nonatomic, readonly) UIImage *image;

@property (nonatomic, readonly) NSString *imagePath;
@property (nonatomic, strong) NSString *downloadedImagePath;

@property (nonatomic, weak) id<IPWRestaurant> restaurant;

@end
