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
	
	self.label.text = @"Сканируйте код прямо за столом вашего любимого ресторана";
	
	self.isReading = NO;
	
	self.captureSession = nil;
	
	[self startStopReading];
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
				[self startStopReading];
				
				if (nil != self.completion)
				{
					self.completion();
				}
			});
		}
	}
}

@end
