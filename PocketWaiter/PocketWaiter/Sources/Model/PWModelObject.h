//
//  PWModelOBject.h
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "IPWJSONInfo.h"

@interface PWModelObject : NSObject <IPWJSONInfo>

- (instancetype)initWithJSONData:(NSData *)jsonData;
- (instancetype)initWithJSONInfo:(id)jsonInfo;

@property (nonatomic, readonly) NSNumber *identifier;

@end
