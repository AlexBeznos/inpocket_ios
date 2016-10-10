//
//  PWUtilsAccessor.m
//  PocketWaiter
//
//  Created by Www Www on 10/10/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWUtilsAccessor.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation PWUtilsAccessor

+ (void)checkAuthStatusForUtilType:(PWAccessUtilType)type completion:(void (^)(PWUtilsAccess))completion
{
	switch (type)
	{
		case kPWAccessUtilTypePhotos:
		{
			[self checkAuthStatusForPhotosWithCompletion:completion];
		}
		break;
		
		case kPWAccessUtilTypeCamera:
		{
			[self checkAuthStatusForCameraWithCompletion:completion];
		}
		break;
	}
}

+ (void)checkAuthStatusForCameraWithCompletion:(void (^)(PWUtilsAccess))completion
{
    if (AVAuthorizationStatusNotDetermined == [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] ||
        AVAuthorizationStatusRestricted == [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo])
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL inGranted)
         {
            dispatch_async(dispatch_get_main_queue(),
            ^{
                completion(inGranted ? kPWUtilsAccessAccepted : kPWUtilsAccessDenied);
            });
         }];
    }
    else
    {
        completion(AVAuthorizationStatusAuthorized ==
					[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] ?
					kPWUtilsAccessAccepted : kPWUtilsAccessDenied);
    }
}

+ (void)checkAuthStatusForPhotosWithCompletion:(void (^)(PWUtilsAccess))completion
{
    if (PHAuthorizationStatusNotDetermined == [PHPhotoLibrary authorizationStatus] ||
                PHAuthorizationStatusRestricted == [PHPhotoLibrary authorizationStatus])
    {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus aStatus)
         {
            dispatch_async(dispatch_get_main_queue(),
            ^{
					completion(PHAuthorizationStatusAuthorized == aStatus ?
								kPWUtilsAccessAccepted : kPWUtilsAccessDenied);
            });
         }];
    }
    else
    {
		completion(PHAuthorizationStatusAuthorized == [PHPhotoLibrary authorizationStatus] ?
					kPWUtilsAccessAccepted : kPWUtilsAccessDenied);
    }
}

@end
