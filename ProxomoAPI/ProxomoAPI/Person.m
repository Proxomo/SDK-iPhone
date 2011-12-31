//
//  Persons.m
//  PROXOMO
//
//  Created by Fred Crable on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "Person.h"

#import <UIKit/UIDevice.h>
#import <UIKit/UIApplication.h>

#define kBaseURL @"https://service.proxomo.com/"

@implementation Person
@synthesize loginDialogView;

-(void)authComplete:(BOOL)success withStatus:(NSString*)status forPerson:(id)person{
    NSLog(@"Proxomo Authentication %@ for %@", status, person);
    if(success){
        _access_token = [loginDialogView access_token];
        _socialnetwork = [loginDialogView socialnetwork];
        _socialnetwork_id = [loginDialogView socialnetwork_id];
        ID = [loginDialogView personID];
        [_apiContext setUserContext:self];
    }
    if(appDelegate){
        [appDelegate asyncObjectComplete:success proxomoObject:self];
    }
}

-(BOOL)isAuthorized {
    return (_access_token != nil && _socialnetwork_id != nil);
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

@end
