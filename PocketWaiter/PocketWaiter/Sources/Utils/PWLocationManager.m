//
//  PWLocationManager.m
//  PocketWaiter
//
//  Created by Www Www on 8/20/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWLocationManager.h"

@interface PWLocationManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic, copy) void (^authCompletion)(CLAuthorizationStatus status, NSError *error);
@property (nonatomic, copy) void (^locationCompletion)(CLLocation *location, NSError *error);

@property (nonatomic) BOOL authChecking;
@property (nonatomic) BOOL locationTracking;

@end

@implementation PWLocationManager

- (CLLocationManager *)locationManager
{
	if (nil == _locationManager)
	{
		_locationManager = [CLLocationManager new];
		_locationManager.delegate = self;
	}
	
	return _locationManager;
}

- (CLAuthorizationStatus)authStatus
{
	return [CLLocationManager authorizationStatus];
}

- (void)getAuthorizationStatusWithCompletion:(void (^)(CLAuthorizationStatus status, NSError *error))completion
{
	if (self.authStatus != kCLAuthorizationStatusNotDetermined)
	{
		if (nil != completion)
		{
			completion(self.authStatus, nil);
		}
	}
	else if (!self.authChecking)
	{
		self.authChecking = YES;
		self.authCompletion = completion;
		
		[self.locationManager requestWhenInUseAuthorization];
	}
	else
	{
		if (nil != completion)
		{
			completion(kCLAuthorizationStatusNotDetermined,
						[NSError errorWithDomain:@"locationAuth" code:-1 userInfo:nil]);
		}
	}
}

- (void)getCurrentLocationWithCompletion:(void (^)(CLLocation *location, NSError *error))completion
{
	[self getAuthorizationStatusWithCompletion:^(CLAuthorizationStatus status, NSError *error) {
		if (nil == error && status == kCLAuthorizationStatusAuthorizedWhenInUse)
		{
			if (!self.locationTracking)
			{
				self.locationTracking = YES;
				self.locationCompletion = completion;
				
				[self.locationManager startUpdatingLocation];
			}
			else
			{
				if (nil != completion)
				{
					completion(nil, [NSError errorWithDomain:@"locationTracking"
								code:-1 userInfo:nil]);
				}
			}
		}
		else
		{
			if (nil != completion)
			{
				completion(nil, [NSError errorWithDomain:@"locationTracking" code:-1 userInfo:nil]);
			}
		}
	}];
}

- (void)locationManager:(CLLocationManager *)manager
			didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	if (newLocation != oldLocation)
	{
		if (fabs(newLocation.coordinate.latitude - oldLocation.coordinate.latitude) < 100 &&
					fabs(newLocation.coordinate.longitude - oldLocation.coordinate.longitude) < 100)
		{
			[self.locationManager stopUpdatingLocation];
			self.locationTracking = NO;
			if (nil != self.locationCompletion)
			{
				self.locationCompletion(newLocation, nil);
				self.locationCompletion = nil;
			}
		}
	}
}

- (void)locationManager:(CLLocationManager *)manager
			didFailWithError:(NSError *)error
{
	if (self.authChecking)
	{
		self.authChecking = NO;
		if (nil != self.authCompletion)
		{
			self.authCompletion(kCLAuthorizationStatusNotDetermined, error);
			self.authCompletion = nil;
		}
	}
	
	if (self.locationTracking)
	{
		self.locationTracking = NO;
		[self.locationManager stopUpdatingLocation];
		if (nil != self.locationCompletion)
		{
			self.locationCompletion(nil, error);
			self.locationCompletion = nil;
		}
	}
}

- (void)locationManager:(CLLocationManager *)manager
			didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
	if (status != kCLAuthorizationStatusNotDetermined)
	{
		if (nil != self.authCompletion)
		{
			self.authCompletion(status, nil);
			self.authCompletion = nil;
		}
		self.authChecking = NO;
	}
}

@end
