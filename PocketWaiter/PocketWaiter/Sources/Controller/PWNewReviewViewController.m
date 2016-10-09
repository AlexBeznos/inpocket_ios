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

@property (nonatomic, strong) UINavigationItem *savedNavigationItem;

@property (nonatomic, strong) UIImagePickerController *picker;

@end

@implementation PWNewReviewViewController

@synthesize transiter;

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor pwBackgroundColor];
	self.holder.backgroundColor = [UIColor whiteColor];
	
	self.postLabel.text = @"Публиковать отзыв";
	self.writeCommentLabel.text = @"Напишите свой отзыв";
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
	theTitleLabel.text = @"Новый отзыв";
	theTitleLabel.font = [UIFont systemFontOfSize:20];
	[theTitleLabel sizeToFit];
	
	item.leftBarButtonItems = @[item.leftBarButtonItem,
				[[UIBarButtonItem alloc] initWithCustomView:theTitleLabel]];
	item.rightBarButtonItems = nil;
}

- (IBAction)postComment:(id)sender
{
}

- (IBAction)addPhoto:(id)sender
{
	self.picker = [UIImagePickerController new];
	self.picker.delegate = self;
	self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentViewController:self.picker animated:YES completion:nil];
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
