//
//  EventComment.m
//  ProxomoAPI
//
//  Created by Fred Crable on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventComment.h"

@implementation EventComment
@synthesize Comment;  //  User supplied comment text for an Event.
@synthesize EventID;  // ID of the Event associated with this comment.
@synthesize LastUpdate; // Date and Time of the last update to this comment.
@synthesize PersonID; // ID of the Person commenting on this Event.
@synthesize PersonName;   // Name of the Person making the comment.

-(enumObjectType) objectType{
    return EVENTCOMMENT_TYPE;
}

-(NSString *) objectPath{
    return @"comment";
}

// adds the object, sets the ID in object
-(void) Add:(id)context  
{   
    if([context isKindOfClass:[Event class]]){
        EventID = [context ID];
    }
    [super Add:context];

}

// @returns true == success, false == failure
-(BOOL) AddSynchronous:(id)context {
    if([context isKindOfClass:[Event class]]){
        EventID = [context ID];
    }
    return [super AddSynchronous:context];
}

// updates or creates a single instance from object
// asynchronously updates or creates a single instance
// ID must be set in object
-(void) Update:(id)context{
    if([context isKindOfClass:[Event class]]){
        EventID = [context ID];
    }
    [super Update:context];

}

// @return true == success, false == failure
-(BOOL) UpdateSynchronous:(id)context{
    if([context isKindOfClass:[Event class]]){
        EventID = [context ID];
    }
    return [super UpdateSynchronous:context];
}

-(void) Delete:(id)context{
    if([context isKindOfClass:[Event class]]){
        EventID = [context ID];
    }
    [super Delete:context];
}

// @returns true == success, false == failure
-(BOOL) DeleteSynchronous:(id)context{
    if([context isKindOfClass:[Event class]]){
        EventID = [context ID];
    }
    return [super DeleteSynchronous:context];
}

-(NSString*)description {
    return Comment;
}

@end
