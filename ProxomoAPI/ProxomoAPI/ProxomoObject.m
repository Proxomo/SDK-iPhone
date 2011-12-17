//
//  ProxomoObject.m
//  ProxomoAPI
//
//  Created by Fred Crable on 11/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ProxomoObject+Proxomo.h"
#import "ProxomoApi+Proxomo.h"

@implementation ProxomoObject

@synthesize restResponse;
@synthesize appDelegate;
@synthesize ID;

-(id) init {
    self = [super init];
    if(self){
        appDelegate = nil;
    }
    return self;
}

-(id)initWithID:(NSString*)objectdId{
    self = [super init];
    if(self){
        [self setID:objectdId];
        appDelegate = nil;
    }
    return self;
}

-(id)initWithContext:(ProxomoApi*)context{
    self = [super init];
    if(self){
        proxomoContext = context;
        appDelegate = nil;
    }
    return self;
}

-(id)initWithContext:(ProxomoApi*)context forAppDelegate:(id<ProxomoAppDelegate>)delegate {
    self = [super init];
    if(self){
        proxomoContext = context;
        appDelegate = delegate;
    }
    return self;
}

// adds the object, sets the ID in object
-(void) Add:(ProxomoApi*)context  
{
    proxomoContext = context;
    [context Add:self];
}

// @returns true == success, false == failure
-(BOOL) AddSynchronous:(ProxomoApi*)context {
    proxomoContext = context;
    return [context AddSynchronous:self];
}

// updates or creates a single instance from object
// asynchronously updates or creates a single instance
// ID must be set in object
-(void) Update:(ProxomoApi*)context{
    proxomoContext = context;
    [context Update:self];
}

// @return true == success, false == failure
-(BOOL) UpdateSynchronous:(ProxomoApi*)context{
    proxomoContext = context;
    return [context UpdateSynchronous:self];
}
// gets an instance by ID
// ID must be set in object
// updates and overwrites current properties
-(void) Get:(id)context{
    proxomoContext = context;
    [context Get:self];
}

// @returns id of new AppData instance
-(BOOL) GetSynchronous:(id)context{
    proxomoContext = context;
    return [context GetSynchronous:self getType:[self objectType]];
}


// deletes a data instance by ID
// ID must be set in object
-(void) Delete:(ProxomoApi*)context{
    proxomoContext = context;
    [context Delete:self];
}

// @returns true == success, false == failure
-(BOOL) DeleteSynchronous:(ProxomoApi*)context{
    proxomoContext = context;
    return [context DeleteSynchronous:[self ID] deleteType:[self objectType]];
}

@end
