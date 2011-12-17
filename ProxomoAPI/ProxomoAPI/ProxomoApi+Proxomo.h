//
//  ProxomoApi+Proxomo.h
//  ProxomoAPI
//
//  Created by Fred Crable on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ProxomoApi.h"

@protocol ProxomoApiDelegate
-(NSMutableDictionary*) jsonRepresentation;
-(void) handleResponse:(NSData*)response requestType:(enumRequestType)requestType responseCode:(NSInteger)code responseStatus:(NSString*) status;
-(void) handleError:(NSData*)response requestType:(enumRequestType)requestType responseCode:(NSInteger)code responseStatus:(NSString*) status;
@end


@interface ProxomoApi (Proxomo)

/*
 * Rest Functions
 */
-(NSString *) htmlEncodeString:(NSString *)input;
-(NSString *)getUrlForRequest:(enumObjectType)objectType requestType:(enumRequestType)requestType;
- (void)makeAsyncRequest:(NSString*)path method:(enumRequestType)method delegate:(id <ProxomoApiDelegate>) requestDelegate;
- (BOOL)makeSyncRequest:(NSString*)path method:(enumRequestType)method delegate:(id <ProxomoApiDelegate>) requestDelegate;

/*
 * General CRUD Functions
 */

/**
 Adds the ProxomoObject, sets the ID in object
 */
-(void) Add:(id)object;
/**
 Adds the ProxomoObject, sets the ID in object
 @returns true == success, false == failure
 */
-(BOOL) AddSynchronous:(id)object;

/**
 Updates or creates a single instance of ProxomoObject.  
 Asynchronously updates or creates a single instance.  
 ID must be set in object.  
 */
-(void) Update:(id)object;
/**
 * Updates or creates the ProxomoObject.
 * sets the ID in object
 @returns true == success, false == failure
 */
-(BOOL) UpdateSynchronous:(id)object;

/**
 deletes a data instance by ID
 ID must be set in object
 */
-(void) Delete:(id)object;
/// @returns true == success, false == failure
-(BOOL) DeleteSynchronous:(NSString*)ID deleteType:(enumObjectType)type;


/*
 * Getters and List operations 
 */

/**
 // gets an instance by ID
 // ID must be set in object
 */
-(void) Get:(id)object;
/// @returns id of new AppData instance
-(BOOL) GetSynchronous:(id)object getType:(enumObjectType)type;

/**
 // gets all of the AppData instances 
 // uses the ProxomoList as the delegate
 */
-(void) GetAll:(id)proxomoList getType:(enumObjectType)type;
/// @returns an array of AppData instances
-(BOOL) GetAll_Synchronous:(id)proxomoList getType:(enumObjectType)getType;

/// General Search
-(void) Search:(id)proxomoList searchUrl:(NSString*)url searchUri:(NSString*)uri forListType:(enumObjectType)objType useAsync:(BOOL)useAsync;

@end
