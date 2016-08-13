//
//  PWQRCodeScannerView.m
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWQRCodeScannerView.h"
#import <AVFoundation/AVFoundation.h>

@interface PWQRCodeScannerView ()

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation PWQRCodeScannerView

- (void)updateWithSession:(AVCaptureSession *)aSession
{
	[self.videoPreviewLayer removeFromSuperlayer];
	self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]
				initWithSession:aSession];
	[self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	if (nil != self.videoPreviewLayer)
	{
		[self.layer insertSublayer:self.videoPreviewLayer atIndex:0];
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	[self.videoPreviewLayer setFrame:self.bounds];
}

@end
