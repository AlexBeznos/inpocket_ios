//
//  PWRequestBuilder.h
//  PocketWaiter
//
//  Created by Www Www on 10/15/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWRequestBuilder : NSObject

+ (NSURLRequest *)authRequest;
+ (NSURLRequest *)signInRequestWithProvider:(NSString *)provider
			email:(NSString *)email password:(NSString *)password
			profile:(PWSocialProfile *)profile;
+ (NSURLRequest *)signUpRequestWithProvider:(NSString *)provider
			email:(NSString *)email password:(NSString *)password
			profile:(PWSocialProfile *)profile;
+ (NSURLRequest *)restaurantRequestWithId:(NSUInteger)identifier;
+ (NSURLRequest *)getUserRequest;
+ (NSURLRequest *)putUserRequestWithUser:(PWUser *)user;
+ (NSURLRequest *)getPlacesRequestForCategory:(NSNumber *)category exceptionPlaceId:(NSNumber *)exceptionId;
+ (NSURLRequest *)getPlaceCategoriesRequest;
+ (NSURLRequest *)getBeaconsRequestForPlace:(NSUInteger)placeId;
+ (NSURLRequest *)getPresentsRequestForPlace:(NSUInteger)placeId page:(NSUInteger)page
			count:(NSUInteger)count exceptionPlaceId:(NSNumber *)exceptionId
			latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;

+ (NSURLRequest *)getFirstPresentRequestForPlace:(NSUInteger)placeId;
+ (NSURLRequest *)getPresentsRequestWithPage:(NSUInteger)page
			count:(NSUInteger)count exceptionPlaceId:(NSNumber *)exceptionId
			latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;
+ (NSURLRequest *)getPresentsRequestForPlace:(NSUInteger)placeId id:(NSUInteger)presentId;
+ (NSURLRequest *)getSharesRequestForPlace:(NSUInteger)placeId page:(NSUInteger)page
			count:(NSUInteger)count exceptionPlaceId:(NSNumber *)exceptionId
			latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;
+ (NSURLRequest *)getMenuCategoriesRequestForPlace:(NSUInteger)placeId;
+ (NSURLRequest *)getProductsRequestForPlace:(NSUInteger)placeId
			categoryId:(NSUInteger)categoryId dayItem:(NSNumber *)dayItemFlag
			page:(NSUInteger)page count:(NSUInteger)count;
+ (NSURLRequest *)getProductWithID:(NSUInteger)productId;
+ (NSURLRequest *)getReviewsRequestForPlace:(NSUInteger)placeId page:(NSUInteger)page
			count:(NSUInteger)count;
+ (NSURLRequest *)postReviewRequest:(PWRestaurantReview *)review;

+ (NSURLRequest *)postPurchaseRequest:(PWPurchase *)review placeId:(NSUInteger)placeId qrCode:(NSString *)code
			beacons:(NSArray *)beacons latitude:(CGFloat)latitude longitude:(CGFloat)longitude;
+ (NSURLRequest *)getPurchasesRequestForPlace:(NSUInteger)placeId page:(NSUInteger)page
			count:(NSUInteger)count;

+ (NSURLRequest *)getCardsRequest;
+ (NSURLRequest *)postReferalsRequestWithToken:(NSString *)token;
@end
