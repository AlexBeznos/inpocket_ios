//
//  PWPhotoController.m
//  PocketWaiter
//
//  Created by Www Www on 10/11/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWPhotoController.h"

@interface PWPhotoController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *label;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic) NSUInteger index;
@property (nonatomic) NSUInteger count;

@end

@implementation PWPhotoController

@synthesize transiter;

- (instancetype)initWithImage:(UIImage *)photo index:(NSUInteger)index count:(NSUInteger)count
{
	self = [super init];
	
	if (nil != self)
	{
		self.image = photo;
		self.index = index;
		self.count = count;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.imageView.image = self.image;
	self.label.text = [NSString stringWithFormat:@"%lu/%li", self.index + 1, self.count];
}

- (void)transitionBack
{
	[self.transiter performBackTransition];
}

- (void)setupWithNavigationItem:(UINavigationItem *)item
{
	[self setupBackItemWithTarget:self action:@selector(transitionBack)
				navigationItem:item];
	item.rightBarButtonItems = nil;
}


@end
