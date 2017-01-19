//
//  PWBluetoothManager.m
//  PocketWaiter
//
//  Created by Www Www on 8/20/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWBluetoothManager.h"

NSInteger const kBluetoothIsNotAvailable = -1;

@interface PWBluetoothManager () <CBCentralManagerDelegate>

@property (strong, nonatomic) CBCentralManager *bluetoothManager;
@property (nonatomic, copy) void (^beaconsHandler)(NSArray<NSString *> *beacons);
@property (nonatomic, copy) void (^errorHandler)(NSError *error);
@property (nonatomic) NSTimeInterval intervalToNotify;

@property (nonatomic, strong) NSMutableSet *beacons;

@end

@implementation PWBluetoothManager

- (CBCentralManager *)bluetoothManager
{
	if (nil == _bluetoothManager)
	{
		_bluetoothManager = [[CBCentralManager alloc]
					initWithDelegate:self queue:nil
					options:@{CBCentralManagerOptionShowPowerAlertKey : @(NO)}];
	}
	
	return _bluetoothManager;
}

- (NSMutableSet *)beacons
{
	if (nil == _beacons)
	{
		_beacons = [NSMutableSet set];
	}
	
	return _beacons;
}

- (CBCentralManagerState)state
{
	return (CBCentralManagerState)[self.bluetoothManager state];
}

- (void)startScanBeaconsForInterval:(NSTimeInterval)interval
			beaconsHandler:(void (^)(NSArray<NSString *> *beacons))beaconsHandler
			errorHandler:(void (^)(NSError *error))errorHandler
{
	if (!(self.state == CBCentralManagerStatePoweredOn || self.state == CBCentralManagerStateUnknown))
	{
		if (nil != errorHandler)
		{
			errorHandler([NSError errorWithDomain:@"bluetooth"
						code:kBluetoothIsNotAvailable userInfo:nil]);
		}
	}
	else if (!self.bluetoothManager.isScanning)
	{
		self.beaconsHandler = beaconsHandler;
		self.errorHandler = errorHandler;
		self.intervalToNotify = interval;
		
		[self.bluetoothManager scanForPeripheralsWithServices:nil options:
					@{CBCentralManagerScanOptionAllowDuplicatesKey : @(NO)}];
	}
}

- (void)stop
{
	@synchronized (self)
	{
		[self.beacons removeAllObjects];
	}
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pullBeacons) object:nil];
	[self.bluetoothManager stopScan];
}

- (void)pullBeacons
{
	[self.bluetoothManager stopScan];
	if (nil != self.beaconsHandler)
	{
		dispatch_async(dispatch_get_main_queue(),
		^{
			self.beaconsHandler([self.beacons allObjects]);
            @synchronized (self)
            {
                [self.beacons removeAllObjects];
            }

		});
	}
	// Removes beacons before callback, I don't know why it's placed here
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
	if (self.state != CBCentralManagerStatePoweredOn)
	{
		[self.bluetoothManager stopScan];
		if (nil != self.errorHandler)
		{
			dispatch_async(dispatch_get_main_queue(),
			^{
				self.errorHandler([NSError errorWithDomain:@"bluetooth"
						code:kBluetoothIsNotAvailable userInfo:nil]);
			});
		}
	}
	else
	{
		[self.bluetoothManager scanForPeripheralsWithServices:nil options:
					@{CBCentralManagerScanOptionAllowDuplicatesKey : @(NO)}];
		[self performSelector:@selector(pullBeacons) withObject:nil afterDelay:self.intervalToNotify];
	}
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
			advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
{
	@synchronized (self)
	{
		[self.beacons addObject:[peripheral identifier]];
	}
}

@end
