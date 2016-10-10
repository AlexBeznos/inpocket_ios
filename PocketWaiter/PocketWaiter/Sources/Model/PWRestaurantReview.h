//
//  PWRestaurantReview.h
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWModelObject.h"

@interface PWRestaurantReview : PWModelObject

- (instancetype)initWithCommentbody:(NSString *)body image:(UIImage *)image;

@property (nonatomic, readonly) UIImage *userIcon;
@property (nonatomic, readonly) NSString *userName;
@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, readonly) NSString *reviewDescription;
@property (nonatomic, readonly) UIImage *photo;
@property (nonatomic) NSUInteger rank;

@end
