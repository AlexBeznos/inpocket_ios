//
//  PWButton.h
//  PocketWaiter
//
//  Created by Www Www on 9/26/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWButton : UIButton

@property (nonatomic) UIColor *colorScheme;
@property (nonatomic) UIColor *bgColor;
@property (nonatomic) NSString *title;

- (void)changeImageWithImage: (NSString *)imageName;

@end
