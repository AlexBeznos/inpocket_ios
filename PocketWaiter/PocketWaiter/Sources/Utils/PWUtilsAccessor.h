//
//  PWUtilsAccessor.h
//  PocketWaiter
//
//  Created by Www Www on 10/10/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PWAccessUtilType)
{
	kPWAccessUtilTypePhotos,
	kPWAccessUtilTypeCamera
};

typedef NS_ENUM(NSUInteger, PWUtilsAccess) {
	kPWUtilsAccessAccepted,
	kPWUtilsAccessDenied
};

@interface PWUtilsAccessor : NSObject

+ (void)checkAuthStatusForUtilType:(PWAccessUtilType)type
			completion:(void (^)(PWUtilsAccess))completion;

@end
