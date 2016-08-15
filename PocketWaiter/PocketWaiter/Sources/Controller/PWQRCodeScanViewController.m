//
//  PWQRCodeScanViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/12/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWQRCodeScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PWQRCodeScannerView.h"

@interface PWQRCodeScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) IBOutlet PWQRCodeScannerView *streamView;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UILabel *flashLabel;
@property (strong, nonatomic) IBOutlet UISwitch *switcher;

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic) BOOL isReading;

@property (nonatomic, copy) void (^completion)();

@end

@implementation PWQRCodeScanViewController

- (instancetype)initWithCompletion:(void (^)())aCompletion;
{
	self = [super init];
	
	if (nil != self)
	{
		self.completion = aCompletion;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
#if 1
	UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
	[button setTitle:@"skip" forState:UIControlStateNormal];
	button.backgroundColor = [UIColor whiteColor];
	[button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	
	[self.view addSubview:button];
	[button sizeToFit];
	button.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"H:[view]-20-|" options:0 metrics:nil
				views:@{@"view" : button}]];
	[self.view addConstraints:[NSLayoutConstraint
				constraintsWithVisualFormat:@"V:[view]-20-|" options:0 metrics:nil
				views:@{@"view" : button}]];
	[button addTarget:self action:@selector(finish)
				forControlEvents:UIControlEventTouchUpInside];
#endif
	
	self.label.text = @"Сканируйте код прямо за столом вашего любимого ресторана";
	self.flashLabel.text = @"Вспышка";
	self.isReading = NO;
	
	self.captureSession = nil;
	
	[self startStopReading];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
				selector:@selector(didEnterBackground)
				name:UIApplicationDidEnterBackgroundNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
				selector:@selector(willEnterForeground)
				name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	if (self.switcher.isOn)
	{
		[self enableFlash:NO];
	}
}

- (void)didEnterBackground
{
	if (self.switcher.isOn)
	{
		[self enableFlash:NO];
	}
}

- (void)willEnterForeground
{
	if (self.switcher.isOn)
	{
		[self enableFlash:YES];
	}
}

- (IBAction)flashSwitch:(id)sender
{
	[self enableFlash:self.switcher.isOn];
}

- (void)enableFlash:(BOOL)enable
{
	AVCaptureDevice *device = [AVCaptureDevice
				defaultDeviceWithMediaType:AVMediaTypeVideo];
	if ([device hasTorch] && [device hasFlash])
	{
		[device lockForConfiguration:nil];
		if (enable)
		{
			[device setTorchMode:AVCaptureTorchModeOn];
			[device setFlashMode:AVCaptureFlashModeOn];
		}
		else
		{
			[device setTorchMode:AVCaptureTorchModeOff];
			[device setFlashMode:AVCaptureFlashModeOff];
		}
		[device unlockForConfiguration];
	}
}

- (BOOL)startReading
{
	NSError *error;
    
	AVCaptureDevice *captureDevice = [AVCaptureDevice
				defaultDeviceWithMediaType:AVMediaTypeVideo];
    
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput
				deviceInputWithDevice:captureDevice error:&error];
	if (!input)
	{
		self.isReading = NO;
	}
    
	self.captureSession = [AVCaptureSession new];
	[self.captureSession addInput:input];
 
	AVCaptureMetadataOutput *captureMetadataOutput =
				[AVCaptureMetadataOutput new];
	[self.captureSession addOutput:captureMetadataOutput];
	
	[captureMetadataOutput setMetadataObjectsDelegate:self
				queue:dispatch_queue_create("myQueue", NULL)];
	[captureMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
	
	[self.streamView updateWithSession:self.captureSession];
	[self.captureSession startRunning];
    
    return YES;
}

- (void)startStopReading
{
	if (!self.isReading)
	{
		[self startReading];
	}
	else
	{
		[self stopReading];
	}
    
	self.isReading = !self.isReading;
}

- (void)stopReading
{
	[self.captureSession stopRunning];
	self.captureSession = nil;
    
	[self.streamView updateWithSession:nil];
}

- (void)finish
{
	[self startStopReading];
				
	if (nil != self.completion)
	{
		self.completion();
		self.completion = nil;
	}

}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
			didOutputMetadataObjects:(NSArray *)metadataObjects
			fromConnection:(AVCaptureConnection *)connection
{
	if (metadataObjects != nil && [metadataObjects count] > 0)
	{
		AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects firstObject];
		if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode])
		{
			NSLog(@"%@", metadataObj.stringValue);
			dispatch_async(dispatch_get_main_queue(),
			^{
				UIView *theSnapshotView = [self.streamView
							snapshotViewAfterScreenUpdates:NO];
				theSnapshotView.translatesAutoresizingMaskIntoConstraints = NO;
				[self.streamView addSubview:theSnapshotView];
				[self.streamView addConstraints:[NSLayoutConstraint
							constraintsWithVisualFormat:@"H:|[view]|" options:0
							metrics:nil views:@{@"view" : theSnapshotView}]];
				[self.streamView addConstraints:[NSLayoutConstraint
							constraintsWithVisualFormat:@"V:|[view]|" options:0
							metrics:nil views:@{@"view" : theSnapshotView}]];
				[self finish];
			});
		}
	}
}

@end
