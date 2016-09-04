//
//  PWSharePromoController.m
//  PocketWaiter
//
//  Created by Www Www on 9/4/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWSharePromoController.h"
#import "PWDropShadowView.h"

@interface PWSharePromoController ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet PWDropShadowView *shadowView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *sendLabel;
@property (nonatomic, copy) void (^completion)(BOOL);

@property (nonatomic, strong) NSString *promo;
@property (strong, nonatomic) IBOutlet UILabel *cancelLabel;

@end

@implementation PWSharePromoController

@synthesize contentSize;

- (instancetype)initWithPromo:(NSString *)promo completion:(void (^)(BOOL))completion
{
	self = [super init];
	
	if (nil != self)
	{
		self.promo = promo;
		self.completion = completion;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.titleLabel.text = @"Промо код";
	self.descriptionLabel.text = @"Высылайте одноразовый промо код для регистрации и вы оба получите по 50 бонусов!";
	self.textField.text = self.promo;
	self.sendLabel.text = @"Готово";
	self.cancelLabel.text = @"Отменить";
	self.shadowView.shadowOffset = CGSizeMake(5, 5);
}

- (IBAction)sendPromo:(UIButton *)sender
{
	// TODO: send promo
	if (nil != self.completion)
	{
		self.completion(YES);
	}
}

- (IBAction)cancel:(UIButton *)sender
{
	if (nil != self.completion)
	{
		self.completion(NO);
	}
}

@end
