//
//  ProxomoObject+Proxomo.m
//  ProxomoAPI
//
//  Created by Fred Crable on 11/30/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "ProxomoApi+Proxomo.h"
#import "ProxomoObject+Proxomo.h"

@implementation ProxomoObject (Proxomo)

#pragma mark - JSON Utilities

-(NSMutableDictionary*)jsonRepresentation{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];  
    if (ID) [dict setValue:ID forKey:@"ID"];
    return dict;
}

-(void) updateFromJsonRepresentation:(NSDictionary*)jsonRepresentation {
    if(jsonRepresentation && 
       [jsonRepresentation isKindOfClass:[NSDictionary class]]) {
            ID = [jsonRepresentation objectForKey:@"ID"];
    }
}

-(void) updateFromJsonData:(NSData*)response {
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    if(error != nil){
        NSLog(@"Error reading JSON data %@", error);
    }else{
        [self updateFromJsonRepresentation:dict];
    }
}

-(id)initFromJsonData:(NSData *)jsonData{
    self = [super init];
    if(self){
        [self updateFromJsonData:jsonData];
    }
    return self;
}

-(id)initFromJsonRepresentation:(NSDictionary*)jsonRepresentation{
    self = [super init];
    if(self){
        [self updateFromJsonRepresentation:jsonRepresentation];
    }
    return self;
}

#pragma mark - API Delegate

-(enumObjectType) objectType{
    return GENERIC_TYPE;
}

-(void) handleResponse:(NSData*)response requestType:(enumRequestType)requestType responseCode:(NSInteger)code responseStatus:(NSString*) status{
    responseCode = code;
    restResponse = status;
    if(requestType == GET){
        [self updateFromJsonData:response];
    } else if (requestType == POST){
        NSError *error;
        NSString *id = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
        if(id != nil && error == nil){
            ID = id;
        }else{
            NSLog(@"Warning - invalid ID returned from server");
        }
    }

    if(appDelegate){
        [appDelegate asyncObjectComplete:(responseCode==200) proxomoObject:self];
    }
    requestType = NONE;
}

-(void) handleError:(NSData*)response requestType:(enumRequestType)requestType responseCode:(NSInteger)code responseStatus:(NSString*) status{
    requestType = NONE;
    responseCode = code;
    restResponse = status;
    if(appDelegate){
        [appDelegate asyncObjectComplete:FALSE proxomoObject:self];
    }
}

@end
