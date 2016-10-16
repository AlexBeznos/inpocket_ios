//
//  PWNearPresentCollectionViewCell.m
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWNearItemCollectionViewCell.h"
#import "PWDropShadowView.h"
#import "PWImageView.h"

@interface PWNearItemCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *buttonLabel;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeDistanceLabel;
@property (strong, nonatomic) IBOutlet PWImageView *imageView;
@property (strong, nonatomic) IBOutlet PWDropShadowView *shadowView;
@property (strong, nonatomic) IBOutlet PWDropShadowView *shadowDescriptionView;

@end

@implementation PWNearItemCollectionViewCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.shadowView.shadowOffset = CGSizeMake(5, 5);
	if (self.deleteDescriptionView)
	{
		[self.shadowDescriptionView removeFromSuperview];
	}
}

- (void)setDeleteDescriptionView:(BOOL)deleteDescriptionView
{
	if (deleteDescriptionView != _deleteDescriptionView)
	{
		_deleteDescriptionView = deleteDescriptionView;
	}
	
	if (_deleteDescriptionView)
	{
		[self.shadowDescriptionView removeFromSuperview];
	}
}

- (void)setColorScheme:(UIColor *)colorScheme
{
	if (nil != colorScheme)
	{
		self.moreButton.backgroundColor = colorScheme;
	}
}

- (void)setButtonTitle:(NSString *)buttonTitle
{
	self.buttonLabel.text = buttonTitle;
}

- (void)setDescriptionTitle:(NSString *)descriptionTitle
{
	self.descriptionLabel.text = descriptionTitle;
}

- (void)setPlaceName:(NSString *)placeName
{
	self.placeNameLabel.text = placeName;
}

- (void)setPlaceDistance:(NSString *)placeDistance
{
	self.placeDistanceLabel.text = placeDistance;
}

- (IBAction)morePressed:(id)sender
{
	if (nil != self.moreHandler)
	{
		self.moreHandler();
	}
}

@end
