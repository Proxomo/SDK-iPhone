//
//  SocialNetworkPFriend.h
//  ProxomoAPI
//
//  Created by Fred Crable on 2/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ProxomoObject.h"

@interface SocialNetworkPFriend : ProxomoObject {
    NSString *FullName; ///	String	Yes	Full Name of the Person as returned from a SocialNetwork.
    NSString *ImageURL; ///	String	Yes	Image URL of the Person as returned from a SocialNetwork.
    NSString *Link;    ///	String	Yes	Link to the Person's SocialNetwork profile.
    NSString *PersonID;
}

@property (nonatomic, strong) NSString *FullName;
@property (nonatomic, strong) NSString *ImageURL;
@property (nonatomic, strong) NSString *Link; 
@property (nonatomic, strong) NSString *PersonID;

@end
