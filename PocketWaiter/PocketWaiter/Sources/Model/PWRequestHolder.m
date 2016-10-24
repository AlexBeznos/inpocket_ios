//
//  PWRequestHolder.m
//  PocketWaiter
//
//  Created by Www Www on 10/15/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRequestHolder.h"

@interface PWRequestHolder ()

@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSMutableData *mutableData;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@end

@implementation PWRequestHolder

- (instancetype)initWithTask:(NSURLSessionDataTask *)task
{
	self = [super init];
	
	if (nil != self)
	{
		self.task = task;
		self.mutableData = [NSMutableData new];
	}
	
	return self;
}

- (void)processData:(NSData *)data
{
	[self.mutableData appendData:data];
}

- (void)processResponse:(NSHTTPURLResponse *)response
{
	self.response = response;
}

- (NSData *)data
{
	return self.mutableData;
}

@end

@interface PWGetCategoryRequestHolder ()

@property (nonatomic, strong) NSString *title;

@end

@implementation PWGetCategoryRequestHolder

- (instancetype)initWithTask:(NSURLSessionDataTask *)task title:(NSString *)title
{
	self = [super initWithTask:task];
	
	if (nil != self)
	{
		self.title = title;
	}
	
	return self;
}

@end
