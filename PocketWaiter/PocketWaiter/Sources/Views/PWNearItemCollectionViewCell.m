//
//  PWNearPresentCollectionViewCell.m
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWNearItemCollectionViewCell.h"
#import "PWDropShadowView.h"

@interface PWNearItemCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *buttonLabel;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeDistanceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet PWDropShadowView *shadowView;

@end

@implementation PWNearItemCollectionViewCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.shadowView.shadowOffset = CGSizeMake(5, 5);
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

- (void)setImage:(UIImage *)image
{
	self.imageView.image = image;
}

- (IBAction)morePressed:(id)sender
{
	if (nil != self.moreHandler)
	{
		self.moreHandler();
	}
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	return [super hitTest:point withEvent:event];
}

@end
