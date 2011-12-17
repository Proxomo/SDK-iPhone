//
//  ProxomoObject+Proxomo.h
//  ProxomoAPI
//
//  Created by Fred Crable on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ProxomoObject.h"
#import "ProxomoApi+Proxomo.h"

@interface ProxomoObject (Proxomo) <ProxomoApiDelegate> 

// JSON Serialization
-(void) updateFromJsonData:(NSData*)response;
-(void) updateFromJsonRepresentation:(NSDictionary*)jsonRepresentation;
-(NSMutableDictionary*)jsonRepresentation;

// init from JSON
-(id) initFromJsonData:(NSData*)jsonData;
-(id) initFromJsonRepresentation:(NSDictionary*)jsonRepresentation;

// What type am I?
-(enumObjectType) objectType;

@end
