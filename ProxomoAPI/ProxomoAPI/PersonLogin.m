//
//  PersonLogin.m
//  ProxomoAPI
//
//  Created by Fred Crable on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PersonLogin.h"

@implementation PersonLogin 
@synthesize PersonID, Role, UserName, ApplicationID, _password, _userToken;

-(enumObjectType) objectType {
    return PERSON_LOGIN_TYPE;
}

-(NSString *) objectPath:(enumRequestType)requestType{
    return @"security/person";
}

-(void) createPerson:(ProxomoApi*)context userName:(NSString*)user password:(NSString*)passwd role:(enumPersonRole)enumRole {
    NSString *role;
    NSDictionary *params;
    if (enumRole == PERSON_ROLE_ADMIN) {
        role = @"Admin";
    }else{
        role = @"User";
    }
    params = [[NSDictionary alloc] initWithObjectsAndKeys:
              user, @"username", 
              passwd, @"password", 
              role, @"role", nil];
    _apiContext = context;
    appDelegate = context.appDelegate;
    UserName = user;
    _password = passwd;
    [context makeRestRequest:@"security/person/create" method:POST params:params delegate:self];
}

-(void) authenticate:(ProxomoApi*)context userName:(NSString*)user password:(NSString*)passwd
{
    NSDictionary *params;
    params = [[NSDictionary alloc] initWithObjectsAndKeys:
              user, @"username", 
              passwd, @"password",
              context.applicationId, @"applicationid", 
              nil];
    _apiContext = context;
    appDelegate = context.appDelegate;
    _authenticationPending = YES;
    _userToken = nil;
    UserName = user;
    _password = passwd;
    [context makeRestRequest:@"/security/person/authenticate" method:GET params:params delegate:self];    
}

-(BOOL) isAuthenticated {
    return _userToken != nil;
}

-(void) updateRole:(ProxomoApi*)context toRole:(enumPersonRole)enumRole
{
    NSString *role;
    NSDictionary *params;
    if (enumRole == PERSON_ROLE_ADMIN) {
        role = @"Admin";
    }else{
        role = @"User";
    }
    params = [[NSDictionary alloc] initWithObjectsAndKeys:
              PersonID, @"personid",
              role, @"role", nil];
    Role = role;
    _apiContext = context;
    appDelegate = context.appDelegate;
    [context makeRestRequest:@"security/person/update/role" method:PUT params:params delegate:self];
}

-(void) passwordChange:(ProxomoApi*)context newPassword:(NSString*)passwd {
    // https://service.proxomo.com/v09/xml/security/person/passwordchange/request/{userName}
    
    NSString *url = [NSString stringWithFormat:@"security/person/passwordchange/request/%@",
                      [ProxomoApi htmlEncodeString:UserName]];
    _passwordChangePending = YES;
    _password = passwd;
    _apiContext = context;
    appDelegate = context.appDelegate;
    [context makeRestRequest:url method:GET params:nil delegate:self];
}

-(Person*)personValue{
    Person *p = [[Person alloc] initWithID:PersonID];
    p.UserName = UserName;
    p.ID = PersonID;
    p._accessToken = _userToken;
    return p;
}

#pragma mark - API Delegate

-(void)updateFromJsonRepresentation:(id)jsonRepresentation{
    [super updateFromJsonRepresentation:jsonRepresentation];
    ID = PersonID; // save for Delete / Update
}

-(NSString*)description {
    return [NSString stringWithFormat:@"%@ - %@/%@", PersonID, UserName, Role];
}

#pragma mark - REST Delegates

-(void)authComplete:(BOOL)success withStatus:(NSString*)status forPerson:(id)person{
    NSLog(@"Proxomo Authentication %@ for %@", status, person);
    if([appDelegate respondsToSelector:@selector(authComplete:withStatus:forPerson:)]){
        [appDelegate authComplete:success withStatus:status forPerson:self];
    }
}

-(void) handleResponse:(NSData*)response requestType:(enumRequestType)requestType responseCode:(NSInteger)code responseStatus:(NSString*) status
{
    NSError *error;
    responseCode = code;
    restResponse = status;
    
    if(_passwordChangePending){
        // use reset token and make passwd change request
        // https://service.proxomo.com/v09/xml/security/person/passwordchange?username={userName}&password={password}&resettoken={passwordResetToken}

        NSString *token = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
        if(token != nil && error == nil){
            NSString *url = [NSString stringWithFormat:@"security/person/passwordchange",
                             [ProxomoApi htmlEncodeString:UserName]];
            NSDictionary *pwParams = [[NSDictionary alloc] initWithObjectsAndKeys:
                      UserName, @"username",
                      _password, @"password", 
                      token, @"resettoken", nil];
            _passwordChangePending = NO;
            [_apiContext makeRestRequest:url method:GET params:pwParams delegate:self];
            return;
        }
    }else if(_authenticationPending){
        NSDictionary *token = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
        if(token != nil && error == nil){
            _userToken = [token objectForKey:@"AccessToken"];
            PersonID = [token objectForKey:@"PersonID"];
        }
        _authenticationPending = NO;
        [self authComplete:(responseCode==200) withStatus:status forPerson:self];
    }else if(requestType == GET || requestType == POST){
        [self updateFromJsonData:response];
    }
    
    if([appDelegate respondsToSelector:@selector(asyncObjectComplete:proxomoObject:)]){
        [appDelegate asyncObjectComplete:(responseCode==200) proxomoObject:self];
    }
}

@end
