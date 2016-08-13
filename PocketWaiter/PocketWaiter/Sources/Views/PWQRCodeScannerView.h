//
//  PWQRCodeScannerView.h
//  PocketWaiter
//
//  Created by Www Www on 8/13/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface PWQRCodeScannerView : UIView

- (void)updateWithSession:(AVCaptureSession *)aSession;

@end
