//
//  PWRequestHolder.h
//  PocketWaiter
//
//  Created by Www Www on 10/15/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWRequestHolder : NSObject

- (instancetype)initWithTask:(NSURLSessionDataTask *)taks;
- (void)processData:(NSData *)data;
- (void)processResponse:(NSHTTPURLResponse *)response;

@property (nonatomic, readonly) NSURLSessionDataTask *task;
@property (nonatomic, readonly) NSData *data;
@property (nonatomic, readonly) NSHTTPURLResponse *response;
@property (nonatomic) BOOL completed;

@end

@interface PWGetCategoryRequestHolder : PWRequestHolder

@property (nonatomic, readonly) NSString *title;

- (instancetype)initWithTask:(NSURLSessionDataTask *)taks title:(NSString *)title;

@end
