//
//  PersonLogin.h
//  ProxomoAPI
//
//  Created by Fred Crable on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProxomoObject.h"

typedef enum {
    PERSON_ROLE_ADMIN = 0,
    PERSON_ROLE_USER = 1
} enumPersonRole;

@interface PersonLogin : ProxomoObject {
    NSString *PersonID; //  Unique identifier for the Person record.
    NSString *ApplicationID;	 //  A unique identifier for your application generated when you registered your application in the Proxomo App Manager.
    NSString *UserName;	 //  UserName for the new user record being created..
    NSString *Role;	 //  Valid values are "admin" or "user". Drives user access or permissions.
    NSString *_password;
    BOOL _passwordChangePending;
}

/**
 * Custom Authentication
 */
-(void) createPerson:(ProxomoApi*)context userName:(NSString*)user password:(NSString*)passwd role:(enumPersonRole)role;
-(void) updateRole:(ProxomoApi*)context toRole:(enumPersonRole)enumRole;
-(void) passwordChange:(ProxomoApi*)context newPassword:(NSString*)passwd;
    
@property (nonatomic, strong) NSString *PersonID;
@property (nonatomic, strong) NSString *ApplicationID;
@property (nonatomic, strong) NSString *UserName;
@property (nonatomic, strong) NSString *Role;
@property (nonatomic, strong) NSString *_password;

@end
