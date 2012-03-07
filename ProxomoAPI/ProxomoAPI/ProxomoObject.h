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
    //NSString *_accessToken;      /// User or Application Login Token
    NSString *restResponse;
    NSInteger responseCode;
    
    // Standard Variables
    NSString *ID; /// Proxomo assigned unique identifier.
}

@property (nonatomic, strong) ProxomoApi *_apiContext;
@property (nonatomic, strong) NSString *_accessToken;
@property (nonatomic, strong) NSString *restResponse;
@property (nonatomic, strong) id appDelegate;
@property (nonatomic, strong) NSString *ID;



-(id) initWithID:(NSString*)objectdId;
-(enumObjectType) objectType;
-(NSString *) objectPath:(enumRequestType)requestType;
-(void) setApiContext:(id)apiContext;


// JSON Serialization
+ (NSString *) dateJsonRepresentation:(NSDate*)date;
-(void) updateFromJsonData:(NSData*)response;
-(void) updateFromJsonRepresentation:(id)jsonRepresentation;
-(NSMutableDictionary*) proxyForJson;

// init from JSON
-(id) initFromJsonData:(NSData*)jsonData;
-(id) initFromJsonRepresentation:(NSDictionary*)jsonRepresentation;

/**
  adds the object using the API context
 */
-(void) Add:(id)context;

/**
 updates or creates a single instance from object
 updates or creates a single instance
 ID must be set in object
 */
-(void) Update:(id)context;

/**
  gets an instance by ID
  updates and overwrites current properties
  @param ID must be set in object before calling
 */
-(void) Get:(id)context;

/**
 deletes an instance by ID
 @param ID must be set in object before calling
 */
-(void) Delete:(id)context;

@end
