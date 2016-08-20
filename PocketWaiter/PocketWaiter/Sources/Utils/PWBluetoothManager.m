//
//  PWBluetoothManager.m
//  PocketWaiter
//
//  Created by Www Www on 8/20/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWBluetoothManager.h"

@interface PWBluetoothManager () <CBCentralManagerDelegate>

@property (strong, nonatomic) CBCentralManager *bluetoothManager;
@property (nonatomic, copy) void (^completion)(NSArray<NSString *> *beacons, NSError *error);
@property (nonatomic) NSTimeInterval intervalToStop;

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
	return [self.bluetoothManager state];
}

- (void)startScanBeaconsForInterval:(NSTimeInterval)interval
			completion:(void (^)(NSArray<NSString *> *beacons, NSError *error))completion
{
	if (!(self.state == CBCentralManagerStatePoweredOn || self.state == CBCentralManagerStateUnknown))
	{
		if (nil != completion)
		{
			completion(nil, [NSError errorWithDomain:@"bluetooth" code:-1 userInfo:nil]);
		}
	}
	else if (!self.bluetoothManager.isScanning)
	{
		self.completion = completion;
		self.intervalToStop = interval;
		
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
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finish) object:nil];
	[self.bluetoothManager stopScan];
}

- (void)finish
{
	[self.bluetoothManager stopScan];
	if (nil != self.completion)
	{
		self.completion([self.beacons allObjects], nil);
	}
	
	@synchronized (self)
	{
		[self.beacons removeAllObjects];
	}
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
	if (self.state != CBCentralManagerStatePoweredOn)
	{
		if (nil != self.completion)
		{
			self.completion(nil, [NSError errorWithDomain:@"bluetooth" code:-1 userInfo:nil]);
		}
		[self.bluetoothManager stopScan];
	}
	else
	{
		[self.bluetoothManager scanForPeripheralsWithServices:nil options:
					@{CBCentralManagerScanOptionAllowDuplicatesKey : @(NO)}];
		[self performSelector:@selector(finish) withObject:nil afterDelay:self.intervalToStop];
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
