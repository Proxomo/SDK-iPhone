//
//  SocialNetworkFriend.m
//  ProxomoAPI
//
//  Created by Fred Crable on 1/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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

-(NSString*) objectPath {
    return @"socialnetwork";
}

@end
