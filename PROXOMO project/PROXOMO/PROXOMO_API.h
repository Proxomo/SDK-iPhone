//
//  PROXOMO_API.h
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 CreativeGurus. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PROXOMODelegate
-(void)ProxomoGeoCodeByIPAddressEventHandler:(NSDictionary*)result;
-(void) AppData_AddEventHandler:(NSString*)response;
-(void) AppData_DeleteEventHandler:(NSString*)response;
-(void) AppData_GetEventHandler:(NSString*)response;
-(void) AppData_GetAllEventHandler:(NSString*)response;
-(void) AppData_UpdateEventHandler:(NSString*)response;
-(void) AppData_SearchEventHandler:(NSString*)response;
@end

@interface PROXOMO_API : NSObject <NSURLConnectionDelegate> {
    NSString* apikey;
    NSString* applicationid;
    NSString* accessToken;
    NSNumber* expires;
    __weak id <PROXOMODelegate> delegate;
    NSMutableURLRequest * request;
    NSMutableData *responseData;
    BOOL isExpired;
}

- (void)makeRequest:(NSString*)path parameters:(NSString*)parameters method:(NSString*)method;

- (void)handleRequest:(NSString*)response;

@property(nonatomic, strong) NSString* apikey;
@property(nonatomic, strong) NSString* applicationid;
@property(nonatomic, strong) NSString* accessToken;

@property(nonatomic, weak) id<PROXOMODelegate> delegate;

@end
