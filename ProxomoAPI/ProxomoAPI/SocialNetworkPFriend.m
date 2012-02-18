//
//  SocialNetworkPFriend.m
//  ProxomoAPI
//
//  Created by Fred Crable on 2/17/12.
//  Copyright (c) 2012 Proxomo. All rights reserved.
//

#import "SocialNetworkPFriend.h"

@implementation SocialNetworkPFriend

@synthesize FullName;
@synthesize ImageURL;
@synthesize Link;
@synthesize PersonID;

-(enumObjectType) objectType{
    return APPFRIEND_TYPE;
}

-(NSString*) objectPath {
    return @"socialnetwork";
}

-(NSString *) description {
    return FullName;
}

@end
