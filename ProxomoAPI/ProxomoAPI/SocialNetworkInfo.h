//
//  SocialNetworkInfo.h
//  ProxomoAPI
//
//  Created by Fred Crable on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProxomoObject.h"

@interface SocialNetworkInfo : ProxomoObject {
    NSString *Key; // Name of the information being stored.
    NSString *PersonID;  // ID of the Person this information is stored for.
    NSInteger SocialNetwork; // Indicates the SocialNetwork this information relates to.
    NSString *Value; // Value of the information being stored.
}

@property (nonatomic, strong) NSString *Key;
@property (nonatomic, strong) NSString *Value;
@property (nonatomic, strong) NSString *PersonID;
@property (nonatomic) NSInteger SocialNetwork;

@end
