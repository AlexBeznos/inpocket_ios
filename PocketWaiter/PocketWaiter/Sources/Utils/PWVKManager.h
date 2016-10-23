//
//  PWVKManager.h
//  PocketWaiter
//
//  Created by Www Www on 10/23/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWVKManager : NSObject

+ (PWVKManager *)sharedManager;

- (void)loginFromController:(UIViewController *)controller
			completion:(void (^)(NSString *accessToken, NSError *error))completion;

- (void)getProfileInfoWithCompletion:(void (^)(NSDictionary *info, NSError *error))completion;

@end
