//
//  PWLocationManager.h
//  PocketWaiter
//
//  Created by Www Www on 8/20/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface PWLocationManager : NSObject

@property (nonatomic, readonly) CLAuthorizationStatus authStatus;

- (void)getAuthorizationStatusWithCompletion:(void (^)(CLAuthorizationStatus status, NSError *error))completion;
- (void)getCurrentLocationWithCompletion:(void (^)(CLLocation *location, NSError *error))completion;

@end
