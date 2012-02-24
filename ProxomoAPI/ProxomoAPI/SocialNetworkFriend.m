//
//  SocialNetworkFriend.m
//  ProxomoAPI
//
//  Created by Fred Crable on 1/2/12.
//  Copyright (c) 2012 Proxomo. All rights reserved.
//

#import "SocialNetworkFriend.h"

@implementation SocialNetworkFriend

@synthesize FullName;
@synthesize ImageURL;
@synthesize Link;
@synthesize SocialNetwork;

-(enumObjectType) objectType{
    return SOCIALNETFRIEND_TYPE;
}

-(NSString*) objectPath:(enumRequestType)requestType {
    return @"friends/personid";
}

-(NSString *) description {
    return FullName;
}

@end
