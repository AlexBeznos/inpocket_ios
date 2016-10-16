//
//  PWImageView.m
//  PocketWaiter
//
//  Created by Www Www on 10/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWImageView.h"
#import "PWActivityIndicator.h"

@interface PWImageView ()

@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, strong) PWActivityIndicator *indicator;
@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) NSURL *downloadedURL;
@property (nonatomic, copy) void (^completion)(NSURL *localURL);

@end

@implementation PWImageView

- (void)downloadImageFromURL:(NSURL *)imageURL completion:(void (^)(NSURL *localURL))completion
{
	self.backgroundColor = [UIColor blackColor];
	if (self.imageURL != imageURL)
	{
		self.completion = completion;
		[self.task cancel];
		
		self.imageURL = imageURL;
		
		[self loadImage];
	}
}

- (void)loadImage
{
	if (nil != self.imageURL)
	{
		[self.reloadButton removeFromSuperview];
		__weak __typeof(self) weakSelf = self;
		[self startActivity];
		self.task = [[NSURLSession sharedSession] downloadTaskWithURL:self.imageURL completionHandler:
		^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error)
		{
			NSURL *url = nil;
			if (nil != location)
			{
				url = [[[NSFileManager defaultManager]
							URLsForDirectory:NSCachesDirectory inDomains:NSAllDomainsMask].firstObject
							URLByAppendingPathComponent:location.lastPathComponent];
				if ([[NSFileManager defaultManager] fileExistsAtPath:url.path])
				{
					[[NSFileManager defaultManager] removeItemAtURL:url error:NULL];
				}
				[[NSFileManager defaultManager] moveItemAtURL:location toURL:url error:NULL];
			}
			
			dispatch_async(dispatch_get_main_queue(),
			^{
				[weakSelf stopActivity];
				
				if (nil == url)
				{
					[weakSelf addReloadButton];
				}
				else
				{
					UIImage *image = [UIImage imageWithContentsOfFile:url.path];
					weakSelf.image = image;
					if (nil != weakSelf.completion)
					{
						weakSelf.completion(url);
						weakSelf.completion = nil;
					}
				}
			});
		}];
		[self.task resume];
	}
}

- (void)startActivity
{
	if (!self.indicator.animating)
	{
		[self addSubview:self.indicator];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self
					attribute:NSLayoutAttributeCenterX
					relatedBy:NSLayoutRelationEqual toItem:self.indicator
					attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self
					attribute:NSLayoutAttributeCenterY
					relatedBy:NSLayoutRelationEqual toItem:self.indicator
					attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
		[self.indicator startAnimating];
	}
}

- (void)stopActivity
{
	if (self.indicator.animating)
	{
		[self.indicator stopAnimating];
		[self.indicator removeFromSuperview];
	}
}

- (PWActivityIndicator *)indicator
{
	if (nil == _indicator)
	{
		_indicator = [PWActivityIndicator new];
		_indicator.translatesAutoresizingMaskIntoConstraints = NO;
		[_indicator addConstraint:[NSLayoutConstraint constraintWithItem:_indicator
					attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
					toItem:nil attribute:NSLayoutAttributeNotAnAttribute
					multiplier:1.0 constant:40]];
		[_indicator addConstraint:[NSLayoutConstraint constraintWithItem:_indicator
					attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
					toItem:nil attribute:NSLayoutAttributeNotAnAttribute
					multiplier:1.0 constant:40]];
	}
	
	return _indicator;
}

- (UIButton *)reloadButton
{
	if (nil == _reloadButton)
	{
		_reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_reloadButton.translatesAutoresizingMaskIntoConstraints = NO;
		[_reloadButton addConstraint:[NSLayoutConstraint constraintWithItem:_reloadButton
					attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
					toItem:nil attribute:NSLayoutAttributeNotAnAttribute
					multiplier:1.0 constant:40]];
		[_reloadButton addConstraint:[NSLayoutConstraint constraintWithItem:_reloadButton
					attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
					toItem:nil attribute:NSLayoutAttributeNotAnAttribute
					multiplier:1.0 constant:40]];
		[_reloadButton setBackgroundImage:[UIImage imageNamed:@"getPresent"]
					forState:UIControlStateNormal];
		[_reloadButton addTarget:self action:@selector(loadImage) forControlEvents:UIControlEventTouchUpInside];
	}
	
	return _reloadButton;
}

- (void)addReloadButton
{
	if (nil == self.reloadButton.superview)
	{
		[self addSubview:self.reloadButton];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self
					attribute:NSLayoutAttributeCenterX
					relatedBy:NSLayoutRelationEqual toItem:self.reloadButton
					attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self
					attribute:NSLayoutAttributeCenterY
					relatedBy:NSLayoutRelationEqual toItem:self.reloadButton
					attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
	}
}

- (void)stopDownloading
{
	if (nil != self.imageURL)
	{
		[self stopActivity];
		[self addReloadButton];
	}
}

@end
