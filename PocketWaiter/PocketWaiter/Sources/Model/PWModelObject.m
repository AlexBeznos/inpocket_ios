//
//  PWModelOBject.m
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWModelObject.h"

@interface PWModelObject ()

@property (nonatomic, strong) NSDictionary *jsonInfo;

@end

@implementation PWModelObject

@synthesize jsonInfo = _jsonInfo;

- (instancetype)initWithJSONData:(NSData *)jsonInfo
{
	self = [super init];
	
	if (nil != self && [NSJSONSerialization isValidJSONObject:jsonInfo])
	{
		id data = [NSJSONSerialization JSONObjectWithData:jsonInfo
					options:NSJSONReadingMutableContainers error:NULL];
		
		if (nil != data && [data isKindOfClass:[NSDictionary class]])
		{
			self.jsonInfo = data;
		}
		else
		{
			self = nil;
		}
	}
	else
	{
		self = nil;
	}
	
	return self;
}

- (instancetype)initWithJSONInfo:(NSDictionary *)jsonInfo
{
	self = [super init];
	
	if (nil != self && nil != jsonInfo &&
				[NSJSONSerialization isValidJSONObject:jsonInfo])
	{
		self.jsonInfo = jsonInfo;
	}
	else
	{
		self = nil;
	}
	
	return self;
}

- (NSData *)jsonData
{
	return [NSJSONSerialization dataWithJSONObject:self.jsonInfo
				options:NSJSONWritingPrettyPrinted error:NULL];
}

@end
