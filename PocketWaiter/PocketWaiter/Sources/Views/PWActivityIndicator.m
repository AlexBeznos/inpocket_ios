//
//  PWActivityIndicator.m
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWActivityIndicator.h"

@interface PWActivityIndicator ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) BOOL animating;

@end

@implementation PWActivityIndicator

+ (void)rotateLayerInfinite:(CALayer *)layer
{
    CABasicAnimation *rotation = [CABasicAnimation
				animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = @0;
    rotation.toValue = @(2 * M_PI);
    rotation.duration = 0.7f; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [layer removeAllAnimations];
    [layer addAnimation:rotation forKey:@"Spin"];
}

- (void)startAnimating
{
	if (!self.animating)
	{
		[PWActivityIndicator rotateLayerInfinite:self.imageView.layer];
		self.animating = YES;
	}
}

- (void)stopAnimating
{
	if (self.animating)
	{
		[self.layer removeAllAnimations];
		self.animating = NO;
	}
}

- (UIImageView *)imageView
{
	if (nil == _imageView)
	{
		_imageView = [[UIImageView alloc] initWithImage:
					[UIImage imageNamed:@"loading"]];
		[_imageView sizeToFit];
		_imageView.translatesAutoresizingMaskIntoConstraints = NO;
		
		[self addSubview:_imageView];
		[self addConstraints:[NSLayoutConstraint
					constraintsWithVisualFormat:@"V:|[view]|"
					options:0 metrics:nil
					views:@{@"view" : _imageView}]];
		[self addConstraints:[NSLayoutConstraint
					constraintsWithVisualFormat:@"H:|[view]|"
					options:0 metrics:nil
					views:@{@"view" : _imageView}]];
	}
	
	return _imageView;
}

@end
