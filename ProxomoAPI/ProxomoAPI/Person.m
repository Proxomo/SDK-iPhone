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
        _accessToken = [loginDialogView access_token];
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
    return (_accessToken != nil && _accessToken != nil);
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
    appDelegate = [apiContext appDelegate];
    
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

-(NSString *) objectPath{
    return @"person";
}

-(NSString *)getAccessToken{
    return _accessToken;
}

@end
