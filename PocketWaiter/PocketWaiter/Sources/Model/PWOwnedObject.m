//
//  PWOwnedObject.m
//  PocketWaiter
//
//  Created by Www Www on 10/24/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWOwnedObject.h"

@interface PWOwnedObject () <IPWRestaurant>

@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSNumber *ownerId;
@property (nonatomic, strong) NSString *ownerName;

@end

@implementation PWOwnedObject

@synthesize address, phoneNumbers, location, restaurantDescription, restaurantImage, thumbnail, color, photos, reviews, workingPlan, logoPath, downloadedLogoURL, collectedBonuses;

- (instancetype)initWithJSONInfo:(id)jsonInfo
{
	self = [super initWithJSONInfo:jsonInfo];
	
	if (nil != self && [jsonInfo isKindOfClass:[NSDictionary class]])
	{
		NSDictionary *info = (NSDictionary *)jsonInfo;
		NSNumber *distance = info[@"distance"];
		self.distance = [NSString stringWithFormat:@"%.1f км", [distance doubleValue]];
		
		NSDictionary *placeInfo = info[@"place"];
		self.ownerName = placeInfo[@"name"];
		self.ownerId = placeInfo[@"id"];
	}
	else
	{
		self = nil;
	}
	
	return self;
}

- (NSString *)restaurantName
{
	return self.ownerName;
}

- (id<IPWRestaurant>)restaurant
{
	return self;
}

@end
