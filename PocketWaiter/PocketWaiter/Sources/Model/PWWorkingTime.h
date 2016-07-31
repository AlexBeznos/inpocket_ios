//
//  PWWorkingTime.h
//  PocketWaiter
//
//  Created by Www Www on 7/31/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWModelObject.h"
#import "PWEnums.h"

@interface PWWorkingTime : PWModelObject

@property (nonatomic) PWWeekDayName dayType;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSTimeInterval finishTime;

@end
