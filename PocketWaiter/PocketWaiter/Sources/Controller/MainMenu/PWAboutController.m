//
//  PWAboutController.m
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWAboutController.h"
#import "UIColorAdditions.h"

@interface PWAboutController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end

@implementation PWAboutController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	self.imageView.image = [UIImage imageNamed:@"aboutlogo"];
	self.label.text = @"Здесь будет размещена информация о нашей команде.";
}

- (NSString *)name
{
	return @"О приложении";
}

@end
