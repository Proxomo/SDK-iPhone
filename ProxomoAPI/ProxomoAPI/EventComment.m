//
//  EventComment.m
//  ProxomoAPI
//
//  Created by Fred Crable on 1/15/12.
//  Copyright (c) 2012 Proxomo. All rights reserved.
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

-(NSString *) objectPath:(enumRequestType)requestType{
    return @"comment";
}

-(NSString*)description {
    return Comment;
}

@end
