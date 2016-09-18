//
//  PWFacebookManager.h
//  PocketWaiter
//
//  Created by Www Www on 9/10/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWFacebookManager : NSObject

+ (PWFacebookManager *)sharedManager;

- (void)loginFromController:(UIViewController *)controller
			completion:(void (^)(NSString *accessToken, NSError *error))completion;

- (void)getProfileInfoWithCompletion:(void (^)(NSDictionary *info, NSError *error))completion;

@end
