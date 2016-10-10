//
//  PWNewReviewViewController.m
//  PocketWaiter
//
//  Created by Www Www on 10/9/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWNewReviewViewController.h"
#import "PWRankView.h"
#import "PWDropShadowView.h"
#import "UIColorAdditions.h"
#import "PWNoAccesViewController.h"
#import "PWThankForReviewViewController.h"
#import "PWUtilsAccessor.h"
#import "PWShareController.h"

@interface PWNewReviewViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UILabel *postLabel;
@property (strong, nonatomic) IBOutlet UILabel *writeCommentLabel;
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;
@property (strong, nonatomic) IBOutlet UILabel *addPhotoLabel;
@property (strong, nonatomic) IBOutlet UILabel *rankLabel;
@property (strong, nonatomic) IBOutlet PWRankView *rankView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (strong, nonatomic) IBOutlet UIView *separator;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet PWDropShadowView *holder;
@property (nonatomic) PWReviewType type;

@property (nonatomic, strong) UINavigationItem *savedNavigationItem;

@property (nonatomic, strong) UIImagePickerController *picker;

@end

@implementation PWNewReviewViewController

@synthesize transiter;

- (instancetype)initWithType:(PWReviewType)type
{
	self = [super init];
	
	if (nil != self)
	{
		self.type = type;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.scrollView removeFromSuperview];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	self.holder.backgroundColor = [UIColor whiteColor];
	
	self.postLabel.text = self.type == kPWReviewTypeComment ?
				@"Публиковать отзыв" : @"Поделиться с друзьями";
	self.writeCommentLabel.text = self.type == kPWReviewTypeComment ?
				@"Напишите свой отзыв" : @"Напишите комментарий";
	self.addPhotoLabel.text = @"Добавить фото";
	self.rankLabel.text = @"Рейтинг";
	
	self.commentTextView.delegate = self;
	
	self.rankView.colorSchema = [UIColor redColor];
	self.rankView.itemsCount = 5;
	self.rankView.rank = 4;
	
	self.commentTextView.text = @"";
}

- (void)transitionBack
{
	[self.transiter performBackTransition];
}

- (void)setupWithNavigationItem:(UINavigationItem *)item
{
	self.savedNavigationItem = item;
	[self setupBackItemWithTarget:self action:@selector(transitionBack)
				navigationItem:item];
	
	UILabel *theTitleLabel = [UILabel new];
	theTitleLabel.text = self.type == kPWReviewTypeComment ? @"Новый отзыв" : @"Напишите комментарий";
	theTitleLabel.font = [UIFont systemFontOfSize:20];
	[theTitleLabel sizeToFit];
	
	item.leftBarButtonItems = @[item.leftBarButtonItem,
				[[UIBarButtonItem alloc] initWithCustomView:theTitleLabel]];
	item.rightBarButtonItems = nil;
}

- (IBAction)postComment:(id)sender
{
	if (0 != self.commentTextView.text.length || nil != self.imageView.image)
	{
		self.view.userInteractionEnabled = NO;
		PWRestaurantReview *review = [[PWRestaurantReview alloc]
					initWithCommentbody:self.commentTextView.text image:self.imageView.image];
		if (self.type == kPWReviewTypeComment)
		{
			[self startActivity];
			__weak __typeof(self) weakSelf = self;
			[[PWModelManager sharedManager] sendReview:review completion:
			^(NSError *error)
			{
				self.view.userInteractionEnabled = YES;
				[weakSelf stopActivity];
				if (nil != error)
				{
					[weakSelf showNoInternetDialog];
				}
				else
				{
					PWThankForReviewViewController *thanksController =
								[[PWThankForReviewViewController alloc]
								initWithReview:review transiter:self.transiter];
					[weakSelf addChildViewController:thanksController];
					thanksController.contentWidth = CGRectGetWidth(self.view.frame);
					[weakSelf.view addSubview:thanksController.view];
					
					[thanksController didMoveToParentViewController:self];
					thanksController.view.translatesAutoresizingMaskIntoConstraints = NO;
					
					[weakSelf.view addConstraints:[NSLayoutConstraint
								constraintsWithVisualFormat:@"V:|[view]|"
								options:0 metrics:nil
								views:@{@"view" : thanksController.view}]];
					[weakSelf.view addConstraints:[NSLayoutConstraint
								constraintsWithVisualFormat:@"H:|[view]|"
								options:0 metrics:nil
								views:@{@"view" : thanksController.view}]];
				}
			}];
		}
		else
		{
			self.view.userInteractionEnabled = NO;
			[PWShareController shareText:review.reviewDescription image:review.photo
						completion:^(NSError *error)
			{
				if (nil != error)
				{
					[self showNoInternetDialog];
				}
				else
				{
					UIAlertController *alert = [UIAlertController
								alertControllerWithTitle:@"Спасибо"
								message:@"Ваш отзыв отправлен"
								preferredStyle:UIAlertControllerStyleAlert];
					[alert addAction:[UIAlertAction actionWithTitle:@"Хорошо" style:UIAlertActionStyleDefault handler:nil]];
					self.view.userInteractionEnabled = NO;
					[self presentViewController:alert animated:YES completion:
					^{
						self.view.userInteractionEnabled = YES;
					}];
				}
			}];

		}
	}
	else
	{
		UIAlertController *alert = [UIAlertController
					alertControllerWithTitle:@"Не удалось публиковать отзыв"
					message:@"Отзыв не может быть пустым"
					preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Хорошо" style:UIAlertActionStyleDefault handler:nil]];
		self.view.userInteractionEnabled = NO;
		[self presentViewController:alert animated:YES completion:
		^{
			self.view.userInteractionEnabled = YES;
		}];
	}
}

- (IBAction)addPhoto:(id)sender
{
	[PWUtilsAccessor checkAuthStatusForUtilType:kPWAccessUtilTypePhotos completion:^(PWUtilsAccess status)
	{
		if (status == kPWUtilsAccessAccepted)
		{
			self.picker = [UIImagePickerController new];
			self.picker.delegate = self;
			self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			[self presentViewController:self.picker animated:YES completion:nil];
		}
		else
		{
			PWNoAccesViewController *noAccess = [[PWNoAccesViewController alloc] initWithType:kPWUtilTypePhotos];
			[noAccess showWithCompletion:nil];
		}
	}];
}

- (void)imagePickerController:(UIImagePickerController *)picker
			didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
	UIImage *image = info[UIImagePickerControllerOriginalImage];
	if (nil != image)
	{
		self.imageView.image = image;
		self.imageHeight.constant = 0.4 * CGRectGetHeight(self.holder.frame);
		self.separator.hidden = YES;
		self.addPhotoLabel.text = @"Выбрать другое фото";
	}
	
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	doneButton.backgroundColor = [UIColor clearColor];
	[doneButton setTitle:@"Готово" forState:UIControlStateNormal];
	[doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
	[doneButton sizeToFit];
	self.savedNavigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]
				initWithCustomView:doneButton]];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	[self done];
}

- (void)done
{
	[self.commentTextView resignFirstResponder];
	self.savedNavigationItem.rightBarButtonItems = nil;
}

@end
