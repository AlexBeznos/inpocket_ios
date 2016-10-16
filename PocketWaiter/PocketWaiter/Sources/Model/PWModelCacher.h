//
//  PWModelCacher.h
//  PocketWaiter
//
//  Created by Www Www on 10/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWModelCacher : NSObject

@property (nonatomic, readonly) NSArray *restaurants;
- (void)cacheRestaurants:(NSArray *)restaurants;

@end
