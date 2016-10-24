//
//  PWUser.m
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWUser.h"
#import "PWRestaurant.h"

@interface PWSocialProfile ()

@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *photoURLPath;

@end

@implementation PWSocialProfile

- (instancetype)initWithUuid:(NSString *)uuid email:(NSString *)email
			gender:(NSString *)gender name:(NSString *)name photoURL:(NSString *)photoURLPath
{
	self = [super init];
	
	if (nil != self)
	{
		self.uuid = uuid;
		self.email = email;
		self.gender = gender;
		self.userName = name;
		self.photoURLPath = photoURLPath;
	}
	
	return self;
}

@end

@interface PWUser ()

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) UIImage *avatarIcon;
@property (nonatomic, strong) NSString *humanReadableName;
@property (nonatomic, strong) NSArray<PWPurchase *> *purchases;
@property (nonatomic, strong) NSString *referalId;
@property (nonatomic, strong) NSString *email;

@end

@implementation PWUser

- (void)updateWithJsonInfo:(NSDictionary *)json
{
	if (NOT_NULL(json[@"first_name"]) && NOT_NULL(json[@"last_name"]))
	{
		self.userName = [NSString stringWithFormat:@"%@ %@", json[@"first_name"], json[@"last_name"]];
	}
	if (NOT_NULL(json[@"referal_number"]))
	{
		self.referalId = json[@"referal_number"];
	}
	
	if (NOT_NULL(json[@"photo"]))
	{
		self.avatarURL = [NSURL URLWithString:json[@"photo"]];
	}
	
	if (NOT_NULL(json[@"loadedImage"]))
	{
		self.avatarIcon = json[@"loadedImage"];
	}
	
	if (NOT_NULL(json[@"password"]))
	{
		self.password = json[@"password"];
	}
	
	if (NOT_NULL(json[@"email"]))
	{
		self.email = json[@"email"];
	}
	
	NSDictionary *vkProfile = NOT_NULL(json[@"vk_profile"]) ? json[@"vk_profile"] : nil;
	
	if (nil != vkProfile)
	{
		if (nil == self.vkProfile)
		{
			self.vkProfile = [PWSocialProfile new];
		}
		PWSocialProfile *vkProfileInfo = self.vkProfile;
		if (NOT_NULL(vkProfile[@"username"]))
		{
			vkProfileInfo.userName = vkProfile[@"username"];
		}
		if (NOT_NULL(vkProfile[@"uid"]))
		{
			vkProfileInfo.uuid = vkProfile[@"uid"];
		}
		if (NOT_NULL(vkProfile[@"gender"]))
		{
			vkProfileInfo.gender = vkProfile[@"gender"];
		}
		if (NOT_NULL(vkProfile[@"email"]))
		{
			vkProfileInfo.email = vkProfile[@"email"];
		}
		if (NOT_NULL(vkProfile[@"remote_photo_url"]))
		{
			vkProfileInfo.photoURLPath = vkProfile[@"remote_photo_url"];
		}
	}
	
	NSDictionary *fbProfile = NOT_NULL(json[@"facebook_profile"]) ?
				json[@"facebook_profile"] : nil;
	
	if (nil != fbProfile)
	{
		if (nil == self.fbProfile)
		{
			self.fbProfile = [PWSocialProfile new];
		}
		PWSocialProfile *fbProfileInfo = self.fbProfile;
		
		if (NOT_NULL(fbProfile[@"username"]))
		{
			fbProfileInfo.userName = fbProfile[@"username"];
		}
		if (NOT_NULL(fbProfile[@"uid"]))
		{
			fbProfileInfo.uuid = fbProfile[@"uid"];
		}
		if (NOT_NULL(fbProfile[@"gender"]))
		{
			fbProfileInfo.gender = fbProfile[@"gender"];
		}
		if (NOT_NULL(fbProfile[@"email"]))
		{
			fbProfileInfo.email = fbProfile[@"email"];
		}
		if (NOT_NULL(fbProfile[@"remote_photo_url"]))
		{
			fbProfileInfo.photoURLPath = fbProfile[@"remote_photo_url"];
		}
	}
}

@end
