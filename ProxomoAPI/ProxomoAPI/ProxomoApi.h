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
    PROXOMOLIST_TYPE,
    SOCIALNETFRIEND_TYPE,
    APPFRIEND_TYPE,
    EVENTCOMMENT_TYPE,
    SOCIALNETWORK_INFO_TYPE,
    CUSTOMDATA_TYPE
} enumObjectType;

typedef enum {
    NONE=0,
    GET=1,
    PUT=2,
    POST=3,
    DELETE=4
} enumRequestType;

@protocol ProxomoApiDelegate
-(NSMutableDictionary*) proxyForJson;
-(void) handleResponse:(NSData*)response requestType:(enumRequestType)requestType responseCode:(NSInteger)code responseStatus:(NSString*) status;
-(void) handleError:(NSData*)response requestType:(enumRequestType)requestType responseCode:(NSInteger)code responseStatus:(NSString*) status;
-(NSString*)getAccessToken;
@end

/** 
 @Class ProxomoAPI Interface to Proxomo Service RESTful Gateway
 Implements both Asynchronous and Synchronous HTTP methods for
 creating content rich applications.  
 */

@interface ProxomoApi : NSObject <NSURLConnectionDelegate> {
    NSString *apiStatus;
    NSInteger apiResultCode;
    
    // basic API information
    NSString *apiKey;           /// Key for API instance issued by Proxomo
    NSString *applicationId;    /// Application ID issued by Proxomo
    NSString *accessToken;      /// User or Application Login Token
    NSString *apiVersion;
    NSNumber *expires;
    NSString *lastError;
    
    // book keeping for async http requests
    NSMutableDictionary *responseData;
    NSMutableDictionary *responseDelegate;
    NSMutableDictionary *responses;
    NSMutableDictionary *requests;
    NSMutableArray *connections;
    
    id appDelegate;
    id userContext;
    NSInteger numAsyncPending;
    BOOL isInAsyncMode;
}

@property(nonatomic, strong) NSString *apiStatus;
@property(nonatomic, strong) NSString *apiKey;
@property(nonatomic, strong) NSString *applicationId;
@property(nonatomic, strong) NSString *accessToken;
@property(nonatomic, strong) NSString *apiVersion;
@property(nonatomic, strong) id appDelegate;
@property(nonatomic, strong) id userContext;
@property(nonatomic, readonly) NSString *lastError;

/**
 * API Initialization Function
 */
-(id) initWithKey:(NSString*)appKey appID:(NSString*)appID;
-(id) initWithKey:(NSString *)appKey appID:(NSString *)appID delegate:(id)delegate;
-(void) setAsync:(BOOL)isAsync;

/*
 * Login Handler
 */
/**
 @returns true when login is complete for application context
 @returns false when login fails
 */
-(BOOL) checkLogin:(id) delegate;
- (BOOL)loginApi:(id) requestDelegate;

-(BOOL) isAsyncPending;
+ (NSString*)serializeURL:(NSString *)baseUrl withParams:(NSDictionary *)params;

/*
 * Rest Functions
 */
+(NSString *) htmlEncodeString:(NSString *)input;
-(NSString *)getUrlForRequest:(id)obj forRequestType:(enumRequestType)requestType;
- (void)makeAsyncRequest:(NSString*)path method:(enumRequestType)method delegate:(id <ProxomoApiDelegate>) requestDelegate;
- (BOOL)makeSyncRequest:(NSString*)path method:(enumRequestType)method delegate:(id <ProxomoApiDelegate>) requestDelegate;

/*
 * General CRUD Functions
 */

/**
 Adds the ProxomoObject, sets the ID in object
 */
-(void) Add:(id)object inObject:(id)path;
/**
 Adds the ProxomoObject, sets the ID in object
 @returns true == success, false == failure
 */
-(BOOL) AddSynchronous:(id)object inObject:(id)path;

/**
 Updates or creates a single instance of ProxomoObject.  
 Asynchronously updates or creates a single instance.  
 ID must be set in object.  
 */
-(void) Update:(id)object inObject:(id)path;
/**
 * Updates or creates the ProxomoObject.
 * sets the ID in object
 @returns true == success, false == failure
 */
-(BOOL) UpdateSynchronous:(id)object inObject:(id)path;

/**
 deletes a data instance by ID
 ID must be set in object
 */
-(void) Delete:(id)object inObject:(id)path;
/// @returns true == success, false == failure
-(BOOL) DeleteSynchronous:(id)object inObject:(id)path;


/*
 * Getters and List operations 
 */

/**
 // gets an instance by ID
 // ID must be set in object
 */
-(void) Get:(id)object inObject:(id)path;
/// @returns id of new AppData instance
-(BOOL) GetSynchronous:(id)object inObject:(id)path;

/**
 // gets all of the AppData instances 
 // uses the ProxomoList as the delegate
 */
-(void) GetAll:(id)proxomoList getType:(enumObjectType)type inObject:(id)path;
/// @returns an array of AppData instances
-(BOOL) GetAll_Synchronous:(id)proxomoList getType:(enumObjectType)type inObject:(id)path;

/// General Search
-(void) Search:(id)proxomoList searchUrl:(NSString*)url searchUri:(NSString*)uri forListType:(enumObjectType)objType useAsync:(BOOL)useAsync inObject:(id)path;
-(void) GetByUrl:(id)obj searchUrl:(NSString*)url searchUri:(NSString*)uri objectType:(enumObjectType)objType useAsync:(BOOL)async;
-(void) Search:(id)proxomoList searchUrl:(NSString*)url searchUri:(NSString*)uri forListType:(enumObjectType)objType inObject:(id)path;
-(void) Query:(id)proxomoList searchUrl:(NSString*)url queryParams:(NSDictionary*)query;

@end
