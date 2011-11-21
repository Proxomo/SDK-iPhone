//
//  PROXOMO_Friends.h
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 CreativeGurus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PROXOMO_API.h"

@interface PROXOMO_Friends : PROXOMO_API {
    
}
-(void) Friends_Get:(NSObject*)object;
-(void) Friend_Invite:(NSObject*)object: (NSObject*) friendb;
-(void) Friend_Invite_bySocialNetwork:(NSObject*)object;
-(void) Friend_Respond:(NSObject*)object;
-(void) Friends_SocialNetwork_Get:(NSObject*)object: (NSObject*) socialnetwork;
-(void) Friends_SocialNetwork_AppGet;

@end
