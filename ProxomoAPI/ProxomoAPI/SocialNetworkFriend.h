//
//  SocialNetworkFriend.h
//  ProxomoAPI
//
//  Created by Fred Crable on 1/2/12.
//  Copyright (c) 2012 Proxomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProxomoObject.h"

@interface SocialNetworkFriend : ProxomoObject {
    NSString *FullName;///	String	Yes	Full Name of the Person as returned from a SocialNetwork.
    NSString *ImageURL;///	String	Yes	Image URL of the Person as returned from a SocialNetwork.
    NSString *Link; ///	String	Yes	Link to the Person's SocialNetwork profile.
    NSInteger *SocialNetwork;
}

@property (nonatomic, strong) NSString *FullName;
@property (nonatomic, strong) NSString *ImageURL;
@property (nonatomic, strong) NSString *Link; 
@property (nonatomic) NSInteger *SocialNetwork;

@end
