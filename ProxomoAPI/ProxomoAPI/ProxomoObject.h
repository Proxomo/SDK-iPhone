//
//  ProxomoObject.h
//  ProxomoAPI
//
//  Created by Fred Crable on 11/27/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProxomoApi.h"

@protocol ProxomoAppDelegate
/**
 Delegate function indicates completion of asynchronous operation
 @returns success or failure to complete operation
 */
-(void)asyncObjectComplete:(BOOL)success proxomoObject:(id)proxomoObject;
@end

@interface ProxomoObject : NSObject <ProxomoApiDelegate> {
    id appDelegate;
    ProxomoApi *_apiContext;
    NSString *_accessToken;      /// User or Application Login Token
    NSString *restResponse;
    NSInteger responseCode;
    
    // Standard Variables
    NSString *ID;
}

@property (nonatomic, strong) ProxomoApi *_apiContext;
@property (nonatomic, strong) NSString *_accessToken;
@property (nonatomic, strong) NSString *restResponse;
@property (nonatomic, strong) id appDelegate;
@property (nonatomic, strong) NSString *ID;



-(id)initWithID:(NSString*)objectdId;
-(enumObjectType) objectType;
-(NSString *) objectPath;


// JSON Serialization
-(void) updateFromJsonData:(NSData*)response;
-(void) updateFromJsonRepresentation:(NSDictionary*)jsonRepresentation;
-(NSMutableDictionary*)proxyForJson;

// init from JSON
-(id) initFromJsonData:(NSData*)jsonData;
-(id) initFromJsonRepresentation:(NSDictionary*)jsonRepresentation;

/**
 asynchronously adds the object using the API context
 */
-(void) Add:(id)context;
/// @returns true == success, false == failure
-(BOOL) AddSynchronous:(id)context;

/**
 updates or creates a single instance from object
 asynchronously updates or creates a single instance
 ID must be set in object
 */
-(void) Update:(id)context;
/// @return true == success, false == failure
-(BOOL) UpdateSynchronous:(id)context;

/**
  gets an instance by ID
  updates and overwrites current properties
  @param ID must be set in object before calling
 */
-(void) Get:(id)context;
/// @returns id of new AppData instance
-(BOOL) GetSynchronous:(id)context;

/**
 deletes an instance by ID
 @param ID must be set in object before calling
 */
-(void) Delete:(id)context;
/// @returns true == success, false == failure
-(BOOL) DeleteSynchronous:(id)context;

@end
