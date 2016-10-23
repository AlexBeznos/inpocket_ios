//
//  PWUser.m
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWUser.h"
#import "PWUsersRestaurantInfo.h"
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
@property (nonatomic, strong) NSArray<PWUsersRestaurantInfo *> *restaurants;
@property (nonatomic, strong) NSString *referalId;
@property (nonatomic, strong) NSString *email;

@end

@implementation PWUser

- (PWUsersRestaurantInfo *)infoForRestaurant:(PWRestaurant *)restaurant
{
	for (PWUsersRestaurantInfo *info in self.restaurants)
	{
		if ([info.restaurantId isEqualToString:restaurant.name])
		{
			return info;
		}
	}
	
	return nil;
}

- (void)updateWithJsonInfo:(NSDictionary *)json
{
	NSString *firstName = json[@"first_name"];
	NSString *lastName = json[@"last_name"];
	self.userName = nil != firstName && nil != lastName ?
				[NSString stringWithFormat:@"%@ %@", firstName, lastName] : nil;
	self.referalId = json[@"referal_number"];
	
	id base64Icon = json[@"photo"];
	
	self.avatarIcon = nil != base64Icon && [NSNull null] != base64Icon &&
				[base64Icon isKindOfClass:[NSString class]] ? [UIImage imageWithData:
				[[NSData alloc] initWithBase64EncodedString:base64Icon options:0]] : nil;
	
	if (nil == self.avatarIcon)
	{
		self.avatarIcon = json[@"loadedImage"];
	}
	self.password = json[@"password"];
	self.email = json[@"email"];
	
	NSDictionary *vkProfile = [NSNull null] != json[@"vk_profile"] ? json[@"vk_profile"] : nil;
	
	if (nil != vkProfile)
	{
		if (nil == self.vkProfile)
		{
			self.vkProfile = [PWSocialProfile new];
		}
		PWSocialProfile *vkProfileInfo = self.vkProfile;
		vkProfileInfo.userName = vkProfile[@"username"];
		vkProfileInfo.uuid = vkProfile[@"uid"];
		vkProfileInfo.gender = vkProfile[@"gender"];
		vkProfileInfo.email = vkProfile[@"email"];
		vkProfileInfo.photoURLPath = vkProfile[@"remote_photo_url"];
	}
	
	NSDictionary *fbProfile = [NSNull null] != json[@"facebook_profile"] ?
				json[@"facebook_profile"] : nil;
	
	if (nil != fbProfile)
	{
		if (nil == self.fbProfile)
		{
			self.fbProfile = [PWSocialProfile new];
		}
		PWSocialProfile *fbProfileInfo = self.fbProfile;
		fbProfileInfo.userName = fbProfile[@"username"];
		fbProfileInfo.uuid = fbProfile[@"uid"];
		fbProfileInfo.gender = fbProfile[@"gender"];
		fbProfileInfo.email = fbProfile[@"email"];
		fbProfileInfo.photoURLPath = fbProfile[@"remote_photo_url"];
	}
}

@end
