//
//  SocialNetworkInfo.m
//  ProxomoAPI
//
//  Created by Fred Crable on 1/16/12.
//  Copyright (c) 2012 Proxomo. All rights reserved.
//

#import "SocialNetworkInfo.h"

@implementation SocialNetworkInfo 
@synthesize PersonID, SocialNetwork, Key, Value;

#pragma mark - API Delegate

-(enumObjectType) objectType{
    return SOCIALNETWORK_INFO_TYPE;
}

-(NSString *) objectPath{
    return @"socialnetworkinfo";
}


@end
