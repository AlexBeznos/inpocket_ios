//
//  PWRequestBuilder.m
//  PocketWaiter
//
//  Created by Www Www on 10/15/16.
//  Copyright © 2016 inPocket. All rights reserved.
//

#import "PWRequestBuilder.h"
#import "PWModelManager.h"

static NSString * const kPWAPIHost = @"api-inpocket.herokuapp.com";

static NSString * const kPWPostMethod = @"POST";
static NSString * const kPWPutMethod = @"PUT";
static NSString * const kPWGetMethod = @"GET";

static NSString * const kPWVersion = @"/v1";
static NSString * const kPWHTTPSScheme = @"https";
static NSString * const kPWHTTPScheme = @"http";

@implementation PWRequestBuilder

+ (NSURLComponents *)baseURLComponent
{
	NSURLComponents *urlComponents = [NSURLComponents new];
	urlComponents.scheme = kPWHTTPSScheme;
	urlComponents.host = kPWAPIHost;
	
	return urlComponents;
}

+ (NSURL *)URLWithPath:(NSString *)path query:(NSDictionary *)query
{
	NSURLComponents *urlComponents = [self baseURLComponent];
	
	urlComponents.path = path;

	if (nil != query)
	{
		NSMutableArray *queryItems = [NSMutableArray array];
		for (NSString *key in query.allKeys)
		{
			[queryItems addObject:[[NSURLQueryItem alloc] initWithName:key value:query[key]]];
		}
		
		urlComponents.queryItems = queryItems;
	}
	
	return [urlComponents URL];
}

+ (NSURLRequest *)requestWithURL:(NSURL *)url method:(NSString *)method
			body:(NSData *)body headers:(NSDictionary *)headers
{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
				cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
	request.HTTPMethod = method;
	for (NSString *key in headers.allKeys)
	{
		[request setValue:headers[key] forHTTPHeaderField:key];
	}

	request.HTTPBody = body;
	
	if (nil != [[PWModelManager sharedManager] authToken])
	{
		[request setValue:[NSString stringWithFormat:@"Token token=%@",
					[[PWModelManager sharedManager] authToken]] forHTTPHeaderField:@"Authorization"];
	}
	
	return request;
}

+ (NSURLRequest *)authRequest
{
	NSDictionary *body = @{ @"device" : @{
					@"platform" : @"ios",
					@"push_token" : @"someToken"
				}};
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body
				options:NSJSONWritingPrettyPrinted error:nil];
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:
				@"devices/authenticate"] query:nil] method:kPWPostMethod
				body:jsonData headers:@{@"Content-Type" : @"application/json"}];
}

+ (NSURLRequest *)signUpRequestWithProvider:(NSString *)provider email:(NSString *)email password:(NSString *)password profile:(PWSocialProfile *)profile
{
	NSMutableDictionary *userBody = [NSMutableDictionary dictionaryWithObject:provider forKey:@"provider"];
	
	if ([provider isEqualToString:@"email"])
	{
		userBody[@"email"] = email;
		userBody[@"password"] = password;
	}
	else
	{
		userBody[@"uid"] = profile.uuid;
		userBody[@"gender"] = profile.gender;
		userBody[@"username"] = profile.userName;
		userBody[@"email"] = profile.email;
		userBody[@"remote_photo_url"] = profile.photoURLPath;
	}
	NSDictionary *body = @{@"user" : userBody};
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body
				options:NSJSONWritingPrettyPrinted error:nil];
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:
				@"users/sign_up"] query:nil] method:kPWPostMethod
				body:jsonData headers:@{@"Content-Type" : @"application/json"}];
}

+ (NSURLRequest *)signInRequestWithProvider:(NSString *)provider email:(NSString *)email password:(NSString *)password profile:(PWSocialProfile *)profile;
{
	NSMutableDictionary *userBody = [NSMutableDictionary dictionaryWithObject:provider forKey:@"provider"];
	
	if ([provider isEqualToString:@"email"])
	{
		userBody[@"email"] = email;
		userBody[@"password"] = password;
	}
	else
	{
		userBody[@"uid"] = profile.uuid;
	}
	NSDictionary *body = @{ @"user" : userBody};
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body
				options:NSJSONWritingPrettyPrinted error:nil];
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:
				@"users/sign_in"] query:nil] method:kPWPostMethod
				body:jsonData headers:@{@"Content-Type" : @"application/json"}];
}

+ (NSURLRequest *)restaurantRequestWithId:(NSUInteger)identifier
{
	return [self requestWithURL:
				[self URLWithPath:[kPWVersion stringByAppendingPathComponent:
				[NSString stringWithFormat:@"places/%li", identifier]] query:nil]
				method:kPWGetMethod
				body:nil headers:@{@"Content-Type" : @"application/json"}];
}

+ (NSURLRequest *)getUserRequest
{
	return [self requestWithURL:
				[self URLWithPath:[kPWVersion stringByAppendingPathComponent:
				@"users/self"] query:nil]
				method:kPWGetMethod body:nil headers:nil];
}

+ (NSURLRequest *)putUserRequestWithUserName:(NSString *)userName
			password:(NSString *)password currentPassword:(NSString *)currentPassword
			email:(NSString *)email avatar:(UIImage *)avatar
			vkInfo:(NSDictionary *)vkInfo fbInfo:(NSDictionary *)fbInfo
{
	NSDictionary *headers = @{@"Content-Type" : @"application/json"};
	
	NSMutableDictionary *userBody = [NSMutableDictionary new];
	
	if (nil != userName)
	{
		NSArray<NSString *> *names = [userName componentsSeparatedByString:@" "];
		userBody[@"first_name"] = names.firstObject;
		userBody[@"last_name"] = names.lastObject;
	}
	
	if (nil != password)
	{
		userBody[@"password"] = password;
	}
	
	if (nil != currentPassword)
	{
		userBody[@"current_password"] = currentPassword;
	}
	
	if (nil != email)
	{
		userBody[@"email"] = email;
	}
	
	if (nil != avatar)
	{
		NSString *photo = [NSString stringWithFormat:@"data:image/jpeg;base64,%@",
					[UIImageJPEGRepresentation(avatar, 1)
					base64EncodedStringWithOptions:0]];
		userBody[@"photo"] = photo;
	}
	
	if (vkInfo.allKeys.count > 0)
	{
		userBody[@"vk_profile"] = vkInfo;
	}
	
	if (fbInfo.allKeys.count > 0)
	{
		userBody[@"facebook_profile"] = fbInfo;
	}
	
	NSDictionary *body = userBody.allKeys.count > 0 ? @{@"user" : userBody} : nil;
	NSData *jsonData = nil != body ? [NSJSONSerialization dataWithJSONObject:body
				options:NSJSONWritingPrettyPrinted error:nil] : nil;
	
	return [self requestWithURL:
				[self URLWithPath:[kPWVersion stringByAppendingPathComponent:@"users/self"] query:nil]
				method:kPWPutMethod body:jsonData headers:headers];
}

+ (NSURLRequest *)getPlacesRequestForCategory:(NSNumber *)category
			uuids:(NSArray *)uuids
			exceptionPlaceId:(NSNumber *)exceptionId page:(NSUInteger)page
			count:(NSUInteger)count
{
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	if (0 != uuids.count)
	{
		NSMutableString *uuidsString = [NSMutableString string];
		
		for (NSString *uuid in uuids)
		{
			[uuidsString appendFormat:@"%@", uuid];
			if (uuid != uuids.lastObject)
			{
				[uuidsString appendString:@","];
			}
		}
		
		query[@"uuid"] = uuidsString;
	}
	query[@"per_page"] = [@(count) stringValue];
	query[@"page"] = [@(page) stringValue];
	if (nil != category)
	{
		query[@"category_id"] = [category stringValue];
	}
	if (nil != exceptionId)
	{
		query[@"places_exclusion"] = [exceptionId stringValue];
	}
	
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:@"places"]
				query:query] method:kPWGetMethod body:nil headers:nil];
}

+ (NSURLRequest *)getPlaceCategoriesRequest
{
	return [self requestWithURL:[self URLWithPath:
				[kPWVersion stringByAppendingPathComponent:@"place_categories"] query:nil]
				method:kPWGetMethod body:nil headers:nil];
}

+ (NSURLRequest *)getBeaconsRequestForPlace:(NSUInteger)placeId
{
	return [self requestWithURL:
				[self URLWithPath:[kPWVersion stringByAppendingPathComponent:
				[NSString stringWithFormat:@"places/%li/beacons", placeId]] query:nil]
				method:kPWGetMethod body:nil headers:nil];
}

+ (NSURLRequest *)getPresentsRequestForPlace:(NSUInteger)placeId page:(NSUInteger)page
			count:(NSUInteger)count exceptionPlaceId:(NSNumber *)exceptionId
			latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude
{
	NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObject:@"page" forKey:[@(page) stringValue]];
	query[@"per_page"] = [@(count) stringValue];
	query[@"place_id"] = [@(placeId) stringValue];
	if (nil != exceptionId)
	{
		query[@"places_exclusion"] = exceptionId;
	}
	if (nil != longitude)
	{
		query[@"lng"] = [longitude stringValue];
	}
	if (nil != latitude)
	{
		query[@"lat"] = [latitude stringValue];
	}
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:
				[NSString stringWithFormat:@"places/%li/presents", placeId]]
				query:query] method:kPWGetMethod body:nil headers:nil];
}

+ (NSURLRequest *)getFirstPresentRequestForPlace:(NSUInteger)placeId
{
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:
				[NSString stringWithFormat:@"places/%li/presents/debut", placeId]]
				query:nil] method:kPWGetMethod body:nil headers:nil];
}

+ (NSURLRequest *)getPresentsRequestWithPage:(NSUInteger)page
			count:(NSUInteger)count exceptionPlaceId:(NSNumber *)exceptionId
			latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude
{
	NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObject:@"page" forKey:[@(page) stringValue]];
	query[@"per_page"] = [@(count) stringValue];
	if (nil != exceptionId)
	{
		query[@"places_exclusion"] = [exceptionId stringValue];
	}
	if (nil != longitude)
	{
		query[@"lng"] = [longitude stringValue];
	}
	if (nil != latitude)
	{
		query[@"lat"] = [latitude stringValue];
	}
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:@"presents"]
				query:query] method:kPWGetMethod body:nil headers:nil];
}

+ (NSURLRequest *)getPresentRequestForPlace:(NSUInteger)placeId id:(NSUInteger)presentId
{
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:
				[NSString stringWithFormat:@"places/%li/presents/%li", placeId, presentId]]
				query:nil] method:kPWGetMethod body:nil headers:nil];
}

+ (NSURLRequest *)getSharesRequestForPlace:(NSUInteger)placeId page:(NSUInteger)page
			count:(NSUInteger)count exceptionPlaceId:(NSNumber *)exceptionId
			latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude
{
	NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObject:@"page" forKey:[@(page) stringValue]];
	query[@"per_page"] = [@(count) stringValue];
	query[@"place_id"] = [@(placeId) stringValue];
	if (nil != exceptionId)
	{
		query[@"places_exclusion"] = [exceptionId stringValue];
	}
	if (nil != longitude)
	{
		query[@"lng"] = [longitude stringValue];
	}
	if (nil != latitude)
	{
		query[@"lat"] = [latitude stringValue];
	}
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:
				[NSString stringWithFormat:@"places/%li/shares", placeId]]
				query:query] method:kPWGetMethod body:nil headers:nil];
}

+ (NSURLRequest *)getSharesRequestWithPage:(NSUInteger)page
			count:(NSUInteger)count exceptionPlaceId:(NSNumber *)exceptionId
			latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude
{
	NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObject:@"page" forKey:[@(page) stringValue]];
	query[@"per_page"] = [@(count) stringValue];
	if (nil != exceptionId)
	{
		query[@"places_exclusion"] = [exceptionId stringValue];
	}
	if (nil != longitude)
	{
		query[@"lng"] = [longitude stringValue];
	}
	if (nil != latitude)
	{
		query[@"lat"] = [latitude stringValue];
	}
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:@"shares"]
				query:query] method:kPWGetMethod body:nil headers:nil];
}

+ (NSURLRequest *)getMenuCategoriesRequestForPlace:(NSUInteger)placeId
{
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:
				[NSString stringWithFormat:@"places/%li/menu_categories", placeId]]
				query:nil] method:kPWGetMethod body:nil headers:nil];
}

+ (NSURLRequest *)getProductsRequestForCategoryId:(NSUInteger)categoryId
			page:(NSUInteger)page count:(NSUInteger)count
{
	NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObject:@"page" forKey:[@(page) stringValue]];
	query[@"per_page"] = [@(count) stringValue];
	
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:
				[NSString stringWithFormat:@"menu_categories/%li/menu_items", categoryId]]
				query:query] method:kPWGetMethod body:nil headers:nil];
}

+ (NSURLRequest *)getProductsRequestForPlace:(NSUInteger)placeId
			dayItem:(NSNumber *)dayItemFlag recomended:(NSNumber *)recomendedFlag
			page:(NSUInteger)page count:(NSUInteger)count
{
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	if (nil != dayItemFlag)
	{
		query[@"day_item"] = [dayItemFlag stringValue];
	}
	if (nil != recomendedFlag)
	{
		query[@"up_sale"] = [recomendedFlag stringValue];
	}
	query[@"page"] = [@(page) stringValue];
	query[@"per_page"] = [@(count) stringValue];
	
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:
				[NSString stringWithFormat:@"places/%li/menu_items", placeId]]
				query:query] method:kPWGetMethod body:nil headers:nil];
}

+ (NSURLRequest *)getProductWithID:(NSUInteger)productId
{
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:
				[NSString stringWithFormat:@"menu_items/%li", productId]]
				query:nil] method:kPWGetMethod body:nil headers:nil];
}

+ (NSURLRequest *)getReviewsRequestForPlace:(NSUInteger)placeId page:(NSUInteger)page
			count:(NSUInteger)count
{
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	query[@"page"] = [@(page) stringValue];
	query[@"per_page"] = [@(count) stringValue];
	
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:
				[NSString stringWithFormat:@"places/%li/feedbacks", placeId]]
				query:query] method:kPWGetMethod body:nil headers:nil];
}

+ (NSURLRequest *)postReviewRequest:(PWRestaurantReview *)review
{
	NSMutableDictionary *feedbackBody = [NSMutableDictionary dictionary];
	
	if (nil != review.reviewDescription)
	{
		feedbackBody[@"content"] = review.reviewDescription;
	}
	
	if (nil != review.reviewDescription)
	{
		NSString *photo = [UIImageJPEGRepresentation(review.photo, 1)
					base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
		feedbackBody[@"image"] = photo;
	}

	NSData *jsonData = feedbackBody.allKeys.count > 0 ?
				[NSJSONSerialization dataWithJSONObject:@{@"feedback" : feedbackBody}
				options:NSJSONWritingPrettyPrinted error:nil] : nil;
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:
				@"devices/authenticate"] query:nil] method:kPWPostMethod
				body:jsonData headers:@{@"Content-Type" : @"application/json"}];
}

+ (NSURLRequest *)postPurchaseRequest:(PWPurchase *)purchase placeId:(NSUInteger)placeId qrCode:(NSString *)code
			beacons:(NSArray *)beacons latitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
	NSMutableDictionary *orderBody = [NSMutableDictionary dictionary];
	
	orderBody[@"uuid"] = [[NSUUID UUID] UUIDString];
	orderBody[@"qr"] = code;
	orderBody[@"lat"] = @(latitude);
	orderBody[@"lng"] = @(longitude);
	
	NSMutableArray *products = [NSMutableArray array];
	
	for (PWOrder *order in purchase.presents)
	{
		[products addObject:@{@"type" : @"present", @"id" : order.product.identifier}];
	}
	
	for (PWOrder *order in purchase.orders)
	{
		[products addObject:@{@"type" : @"menu_item", @"id" : order.product.identifier}];
	}

	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"order" : orderBody}
				options:NSJSONWritingPrettyPrinted error:nil];
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:
				[NSString stringWithFormat:@"places/%li/orders", placeId]] query:nil] method:kPWPostMethod
				body:jsonData headers:@{@"Content-Type" : @"application/json"}];
}

+ (NSURLRequest *)getPurchasesRequestForPlace:(NSUInteger)placeId page:(NSUInteger)page
			count:(NSUInteger)count
{
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	query[@"page"] = [@(page) stringValue];
	query[@"per_page"] = [@(count) stringValue];
	
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:
				[NSString stringWithFormat:@"places/%li/orders", placeId]]
				query:query] method:kPWGetMethod body:nil headers:nil];
}

+ (NSURLRequest *)getCardsRequest
{
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:@"cards"]
				query:nil] method:kPWGetMethod body:nil headers:nil];
}

+ (NSURLRequest *)postReferalsRequestWithToken:(NSString *)token
{
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"order" : @{@"number" : token}}
				options:NSJSONWritingPrettyPrinted error:nil];
	return [self requestWithURL:[self URLWithPath:[kPWVersion stringByAppendingPathComponent:@"referals"]
				query:nil] method:kPWPostMethod
				body:jsonData headers:@{@"Content-Type" : @"application/json"}];
}

@end
