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

@interface PWUser ()

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) UIImage *avatarIcon;
@property (nonatomic, strong) NSString *humanReadableName;
@property (nonatomic, strong) NSArray<PWPurchase *> *purchases;
@property (nonatomic, strong) NSArray<PWUsersRestaurantInfo *> *restaurants;

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

@end
