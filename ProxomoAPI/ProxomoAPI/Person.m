//
//  Persons.m
//  PROXOMO
//
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "Person.h"
#import "AppData.h"

#import <UIKit/UIDevice.h>
#import <UIKit/UIApplication.h>

#define kBaseURL @"https://service.proxomo.com/"

@implementation Person

@synthesize EmailAddress;
@synthesize EmailAlerts; 
@synthesize EmailVerificationCode;
@synthesize EmailVerificationStatus; 
@synthesize EmailVerified; 
@synthesize FacebookID; ///	String	No	Facebook unique identifier.
@synthesize FirstName; ///	String	Yes	First Name of the Person.
@synthesize FullName; ///	String	Yes	Full Name of the Person.
@synthesize ImageURL; ///	String	No	Image URL of the Person.
@synthesize LastLogin; ///	DateTime	No	Last Date and Time the Person logged into Proxomo.
@synthesize LastName; ///	String	Yes	Last Name of the Person.
@synthesize MobileAlerts; 
@synthesize MobileNumber; ///	String	No	Mobile phone number of the Person.
@synthesize MobileVerificationCode;
@synthesize MobileVerificationStatus;
@synthesize MobileVerified;
@synthesize TwitterID;
@synthesize UserName;
@synthesize UTCOffset;

-(void)authComplete:(BOOL)success withStatus:(NSString*)status forPerson:(id)person{
    NSLog(@"Proxomo Authentication %@ for %@", status, person);
    if(success){
        //_accessToken = [loginDialogView access_token];
        _socialnetwork = [loginDialogView socialnetwork];
        _socialnetwork_id = [loginDialogView socialnetwork_id];
        ID = [loginDialogView personID];
        [_apiContext setUserContext:self];
    }
    if([appDelegate respondsToSelector:@selector(authComplete:withStatus:forPerson:)]){
        [appDelegate authComplete:success withStatus:status forPerson:self];
    }
}

-(BOOL)isAuthorized {
    return (_socialnetwork != nil && _socialnetwork_id != nil);
}

-(void)loginToSocialNetwork:(enumSocialNetwork)network forApplication:(id)apiContext{
    /*
     application_id={applicationid}&display_type=mobile&auth_token={auth_token}
     */
    if([apiContext checkLogin:self]==NO){
        NSLog(@"Application Context is not Logged into Proxomo");
        return;
    }
    _apiContext = apiContext;
    if(!appDelegate){
        appDelegate = [apiContext appDelegate];
    }
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"mobile", @"display_type",
                                   [_apiContext applicationId], @"application_id",
                                   [_apiContext accessToken], @"auth_token",
                                   nil];
    NSString *loginURL = [kBaseURL stringByAppendingString:@"login.aspx"];
    NSString *urlWithParams = [ProxomoApi serializeURL:loginURL withParams:params];
    NSLog(@"Login: %@",urlWithParams);
    loginDialogView = [[AuthorizeDialog alloc] initWithURL:loginURL loginParams:params appDelegate:self];
    [loginDialogView expose];
}

#pragma mark - API Delegate

-(enumObjectType) objectType{
    return PERSON_TYPE;
}

-(NSString *) objectPath:(enumRequestType)requestType{
    return @"person";
}

-(NSString*)description{
    return FullName;
}

-(NSArray*)appData{
    return [_appData arrayValue];
}

#pragma mark - Friends

-(void)friendInvite:(NSString*)personID{
    NSString *url = [NSString stringWithFormat:@"%@friend/invite/frienda/%@/friendb/%@", 
                     [_apiContext getUrlForRequest:nil forRequestType:PUT], 
                     self.ID,
                     personID];
    
    [_apiContext makeRestRequest:url method:PUT params:nil delegate:self];
}

-(void)friendInvite:(NSString*)socialID inSocialNetwork:(enumSocialNetwork)network {
    NSString *url = [NSString stringWithFormat:@"%@friend/invite/frienda/%@/friendb/%@/socialnetwork/%d", 
                     [_apiContext getUrlForRequest:nil forRequestType:PUT], 
                     _socialnetwork_id,
                     socialID,
                     (NSInteger)network];
    
    [_apiContext makeRestRequest:url method:PUT params:nil delegate:self];
}

-(void)friendRespond:(NSString*)personID withResponse:(enumFriendResponse)response {
    NSString *url = [NSString stringWithFormat:@"%@friend/respond/frienda/%@/friendb/%@/friendresponse/%d", 
                     [_apiContext getUrlForRequest:nil forRequestType:PUT], 
                     ID,
                     personID,
                     (NSInteger)response];
    
    [_apiContext makeRestRequest:url method:PUT params:nil delegate:self];
}


@end
