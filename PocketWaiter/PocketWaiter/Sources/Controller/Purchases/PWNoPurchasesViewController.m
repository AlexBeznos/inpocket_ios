//
//  PWNoPurchasesViewController.m
//  PocketWaiter
//
//  Created by Www Www on 8/16/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWNoPurchasesViewController.h"
#import "UIColorAdditions.h"

@interface PWNoPurchasesViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end

@implementation PWNoPurchasesViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.label.text = @"Здесь будет отображаться ваша история заказа и "
				"накопленные бонусы.\nВы еще ничего не заказали с помощью нашего "
				"приложения.\nЧтобы выполнить заказ перейдитев ваше любимое "
				"заведение и закажите свое любимое блюдо.";
	self.imageView.image = [UIImage imageNamed:@"aboutlogo"];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
}

@end
