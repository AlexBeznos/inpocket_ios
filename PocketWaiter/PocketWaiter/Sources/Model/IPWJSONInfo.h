//
//  IPWJSONInfo.h
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

@protocol IPWJSONInfo <NSObject>

@property (nonatomic, readonly) NSDictionary *jsonInfo;
- (NSData *)jsonData;

@end
