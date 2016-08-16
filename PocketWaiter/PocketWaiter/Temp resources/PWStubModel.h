//
//  PWStubModel.h
//  PocketWaiter
//
//  Created by Www Www on 8/7/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRestaurantShare.h"
#import "PWRestaurant.h"
#import "PWRestaurantReview.h"
#import "PWRestaurantAboutInfo.h"
#import "PWPresentProduct.h"
#import "PWPrice.h"
#import "PWOrder.h"
#import "PWPurchase.h"
#import "PWUser.h"
#import "PWUsersRestaurantInfo.h"
#import "PWWorkingTime.h"

@interface PWRestaurant (StubAccess)

@property (nonatomic, strong) PWRestaurantAboutInfo *aboutInfo;
@property (nonatomic, strong) NSArray<PWRestaurantShare *> *shares;
@property (nonatomic, strong) NSArray<PWProduct *> *products;
@property (nonatomic, strong) NSArray<PWPresentProduct *> *presents;

@end

@interface PWRestaurantShare (StubAccess)

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *shareDescription;
@property (nonatomic, strong) UIImage *image;

@end

@interface PWPrice (StubAccess)

@property (nonatomic) PWPriceCurrency currency;
@property (nonatomic) CGFloat value;
@property (nonatomic, strong) NSString *humanReadableValue;

@end

@interface PWProduct (StubAccess)

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *productDescription;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) PWPrice *price;
@property (nonatomic) NSUInteger bonusesValue;
@property (nonatomic) PWProductType type;

@end

@interface PWPresentProduct (StubAccess)

@property (nonatomic) NSUInteger bonusesPrice;

@end

@interface PWRestaurantReview (StubAccess)

@property (nonatomic, strong) UIImage *userIcon;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *reviewDescription;
@property (nonatomic, strong) UIImage *photo;

@end

@interface PWPurchase (StubAccess)

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray<PWOrder *> *orders;
@property (nonatomic, strong) NSArray<PWOrder *> *presents;
@property (nonatomic, strong) NSString *restaurantId;

@end

@interface PWUser (StubAccess)

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) UIImage *avatarIcon;
@property (nonatomic, strong) NSString *humanReadableName;
@property (nonatomic, strong) NSArray<PWPurchase *> *purchases;
@property (nonatomic, strong) NSArray<PWUsersRestaurantInfo *> *restaurants;

@end

@interface PWUsersRestaurantInfo (StubAccess)

@property (nonatomic, strong) NSString *restaurantId;
@property (nonatomic, strong) NSDate *lastCommingDate;
@property (nonatomic) NSUInteger collectedBonuses;
@property (nonatomic, strong) NSString *sessionToken;

@end

@interface PWRestaurantAboutInfo (StubAccess)

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *restaurantDescription;
@property (nonatomic, strong) UIImage *restaurantImage;
@property (nonatomic, strong) NSArray<UIImage *> *photos;
@property (nonatomic, strong) NSArray<PWRestaurantReview *> *reviews;
@property (nonatomic, strong) NSArray<PWWorkingTime *> *workingPlan;

@end
