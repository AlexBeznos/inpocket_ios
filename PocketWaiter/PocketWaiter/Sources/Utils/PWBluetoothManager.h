//
//  PWBluetoothManager.h
//  PocketWaiter
//
//  Created by Www Www on 8/20/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

extern NSInteger const kBluetoothIsNotAvailable;

@interface PWBluetoothManager : NSObject

@property (nonatomic, readonly) CBCentralManagerState state;

- (void)startScanBeaconsForInterval:(NSTimeInterval)interval
			beaconsHandler:(void (^)(NSArray<NSString *> *beacons))beaconsHandler
			errorHandler:(void (^)(NSError *error))errorHandler;

- (void)stop;

@end
