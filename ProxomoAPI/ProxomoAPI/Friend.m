//
//  Friend.m
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "Friend.h"
#import "Person.h"
#import "ProxomoApi.h"

@implementation Friend

@synthesize FacebookID;    ///	FacebookID for this Person
@synthesize FirstName;     ///	First Name for this Person
@synthesize FriendStatus;  /// Status of this Friendship
@synthesize FullName;      /// Full Name for this Person
@synthesize ImageURL;      ///	Image URL for this Person
@synthesize LastName;      ///	Last Name for this Person
@synthesize PersonID;      ///	ID for this Person
@synthesize TwitterID;     

-(enumObjectType) objectType {
    return FRIEND_TYPE;
}

-(NSString *) objectPath {
    return @"friend";
}

-(NSString *) description {
    return [NSString stringWithFormat:@"%@, %@", FullName, PersonID];
}

@end
