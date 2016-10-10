//
//  PWShareController.h
//  PocketWaiter
//
//  Created by Www Www on 10/10/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWShareController : NSObject

+ (void)shareText:(NSString *)text image:(UIImage *)image completion:(void (^)(NSError *error))completion;

@end
