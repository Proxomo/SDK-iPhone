//
//  PROXOMO_Friends.m
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 CreativeGurus. All rights reserved.
//

#import "PROXOMO_Friends.h"
#import "SBJson.h"

@interface PROXOMO_Friends()

@end

@implementation PROXOMO_Friends

-(void) Friends_Get:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/friends/personid/%@",object ] parameters:@"" method:@"GET"];
}
-(void) Friend_Invite:(NSObject*)object: (NSObject*) friendb{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/friend/invite/frienda/%@/friendb/%@",object,friendb ] parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) Friend_Invite_bySocialNetwork:(NSObject*)object{
    //no info on website
}
-(void) Friend_Respond:(NSObject*)object{
    //no info on website
}
-(void) Friends_SocialNetwork_Get:(NSObject*)object: (NSObject*) socialnetwork{

    [self makeRequest:[NSString stringWithFormat:@"/v09/json/friends/personid/%@/socialnetwork/%@",object,socialnetwork ] parameters:@"" method:@"GET"];
}
-(void) Friends_SocialNetwork_AppGet{
    //no info on website
}

@end
