//
//  ProxomoApi.h
//  ProxomoApi
//
//  Created by Fred Crable on 11/23/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  
{
    All = 0,
    GlobalOnly = 1,
    ApplicationOnly = 2
} enumLocationSearchScope;

typedef enum {
    GENERIC_TYPE,
    APPDATA_TYPE,
    FRIEND_TYPE,
    EVENT_TYPE,
    GEOCODE_TYPE,
    LOCATION_TYPE,
    NOTIFICATION_TYPE,
    PERSON_TYPE,
    PROXOMOLIST_TYPE
} enumObjectType;

typedef enum {
    NONE=0,
    GET=1,
    PUT=2,
    POST=3,
    DELETE=4
} enumRequestType;

/** 
 @Class ProxomoAPI Interface to Proxomo Service RESTful Gateway
 Implements both Asynchronous and Synchronous HTTP methods for
 creating content rich applications.  
 */

@interface ProxomoApi : NSObject <NSURLConnectionDelegate> {
    NSString *apiStatus;
    NSInteger apiResultCode;
    
    // basic API information
    NSString *apiKey;
    NSString *applicationId;
    NSString *accessToken;
    NSString *apiVersion;
    NSNumber *expires;
    
    // book keeping for async http requests
    NSMutableDictionary *responseData;
    NSMutableDictionary *responseDelegate;
    NSMutableDictionary *responses;
    NSMutableDictionary *requests;
    NSDictionary *encode_url_table;
    NSMutableArray *connections;
    
    id appDelegate;
    NSInteger numAsyncPending;
}

@property(nonatomic, strong) NSString *apiStatus;
@property(nonatomic, strong) NSString *apiKey;
@property(nonatomic, strong) NSString *applicationId;
@property(nonatomic, strong) NSString *accessToken;
@property(nonatomic, strong) NSString *apiVersion;
@property(atomic, strong) id appDelegate;

/**
 * API Initialization Function
 */
-(id) initWithKey:(NSString*)appKey appID:(NSString*)appID;
-(BOOL) isAsyncPending;


@end
