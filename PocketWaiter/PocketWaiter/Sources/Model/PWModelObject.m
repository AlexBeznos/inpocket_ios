//
//  PWModelOBject.m
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWModelObject.h"

@interface PWModelObject ()

@property (nonatomic, strong) id jsonInfo;
@property (nonatomic, strong) NSNumber *identifier;

@end

@implementation PWModelObject

@synthesize jsonInfo = _jsonInfo;

- (instancetype)initWithJSONData:(NSData *)jsonInfo
{
	id data = [NSJSONSerialization JSONObjectWithData:jsonInfo
				options:NSJSONReadingMutableContainers error:NULL];
	
	return [self initWithJSONInfo:data];
}

- (instancetype)initWithJSONInfo:(id)jsonInfo
{
	self = [super init];
	
	if (nil != self && nil != jsonInfo &&
				[NSJSONSerialization isValidJSONObject:jsonInfo] &&
				[jsonInfo isKindOfClass:[NSDictionary class]])
	{
		self.jsonInfo = jsonInfo;
		NSDictionary *info = (NSDictionary *)jsonInfo;
		self.identifier = info[@"id"];
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
