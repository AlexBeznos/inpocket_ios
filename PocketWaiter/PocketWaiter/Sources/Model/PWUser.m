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
	if (nil != firstName && nil != lastName)
	{
		self.userName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
	}
	if (nil != json[@"referal_number"])
	{
		self.referalId = json[@"referal_number"];
	}
	
	if (nil != json[@"photo"])
	{
		id base64Icon = json[@"photo"];
	
		self.avatarIcon = nil != base64Icon && [NSNull null] != base64Icon &&
					[base64Icon isKindOfClass:[NSString class]] ? [UIImage imageWithData:
					[[NSData alloc] initWithBase64EncodedString:base64Icon options:0]] : nil;
	}
	
	if (nil != json[@"loadedImage"])
	{
		self.avatarIcon = json[@"loadedImage"];
	}
	
	if (nil != json[@"password"])
	{
		self.password = json[@"password"];
	}
	
	if (nil != json[@"email"])
	{
		self.email = json[@"email"];
	}
	
	NSDictionary *vkProfile = [NSNull null] != json[@"vk_profile"] ? json[@"vk_profile"] : nil;
	
	if (nil != vkProfile)
	{
		if (nil == self.vkProfile)
		{
			self.vkProfile = [PWSocialProfile new];
		}
		PWSocialProfile *vkProfileInfo = self.vkProfile;
		if (nil != vkProfile[@"username"])
		{
			vkProfileInfo.userName = vkProfile[@"username"];
		}
		if (nil != vkProfile[@"uid"])
		{
			vkProfileInfo.uuid = vkProfile[@"uid"];
		}
		if (nil != vkProfile[@"gender"])
		{
			vkProfileInfo.gender = vkProfile[@"gender"];
		}
		if (nil != vkProfile[@"email"])
		{
			vkProfileInfo.email = vkProfile[@"email"];
		}
		if (nil != vkProfile[@"remote_photo_url"])
		{
			vkProfileInfo.photoURLPath = vkProfile[@"remote_photo_url"];
		}
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
		
		if (nil != fbProfile[@"username"])
		{
			fbProfileInfo.userName = fbProfile[@"username"];
		}
		if (nil != fbProfile[@"uid"])
		{
			fbProfileInfo.uuid = fbProfile[@"uid"];
		}
		if (nil != fbProfile[@"gender"])
		{
			fbProfileInfo.gender = fbProfile[@"gender"];
		}
		if (nil != fbProfile[@"email"])
		{
			fbProfileInfo.email = fbProfile[@"email"];
		}
		if (nil != fbProfile[@"remote_photo_url"])
		{
			fbProfileInfo.photoURLPath = fbProfile[@"remote_photo_url"];
		}
	}
}

@end
