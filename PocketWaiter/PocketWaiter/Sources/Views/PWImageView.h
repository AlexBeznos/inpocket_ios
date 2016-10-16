//
//  PWImageView.h
//  PocketWaiter
//
//  Created by Www Www on 10/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWImageView : UIImageView

- (void)downloadImageFromURL:(NSURL *)imageURL completion:(void (^)(NSURL *localURL))completion;
- (void)stopDownloading;

@end
