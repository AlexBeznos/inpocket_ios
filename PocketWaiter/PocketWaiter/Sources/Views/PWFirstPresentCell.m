//
//  PWFirstPresentCell.m
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWFirstPresentCell.h"
#import "PWButton.h"

@interface PWFirstPresentCell ()

@property (strong, nonatomic) IBOutlet PWButton *getButton;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *presentImageView;
@property (strong, nonatomic) IBOutlet UILabel *yourFirstPresentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *presentColoredView;

@end

@implementation PWFirstPresentCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.getButton.title = @"Получить";
	self.yourFirstPresentLabel.text = @"Ваш первый подарок";
}

- (IBAction)getPresent:(PWButton *)sender
{
	if (nil != self.getPresentHandler)
	{
		self.getPresentHandler();
	}
}

- (void)setColorScheme:(UIColor *)colorScheme
{
	self.getButton.bgColor = colorScheme;
	self.getButton.colorScheme = [UIColor whiteColor];
	self.yourFirstPresentLabel.textColor = colorScheme;
	self.presentColoredView.image = [[UIImage imageNamed:@"collectedBonus"]
				imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[self.presentColoredView setTintColor:colorScheme];
}

- (UIColor *)colorScheme
{
	return self.getButton.bgColor;
}

@end
