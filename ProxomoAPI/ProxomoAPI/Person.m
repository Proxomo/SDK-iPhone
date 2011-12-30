//
//  Persons.m
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "Person.h"
#import "ProxomoApi+Proxomo.h"
#import <UIKit/UIDevice.h>
#import <UIKit/UIApplication.h>

@implementation Person
@synthesize loginDialogView;

-(void)authComplete:(BOOL)success withStatus:(NSString*)status forPerson:(id)person{
    NSLog(@"Auth %@ for %@",status,person);
}

-(void)loginToSocialNetwork:(enumSocialNetwork)network{
    /*
     application_id={applicationid}&display_type=mobile&auth_token={auth_token}
     */
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [proxomoContext applicationId] , @"application_id",
                                   [proxomoContext accessToken], @"auth_token",
                                   nil];
    NSString *loginURL = @"https://service.proxomo.com/login.aspx";
    NSString *openURL = nil;
    
    NSLog(@"%@/%@", loginURL, params);
    BOOL didOpenOtherApp = NO;
/*
    BOOL doAppAuth = YES;
    BOOL doSafariAuth = YES;
    
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)] && [device isMultitaskingSupported]) {
        if (doAppAuth) {
            [params setValue:@"page" forKey:@"display_type"];
            [params setValue:@"http://developer.proxomo.com" forKey:@"response_url"];          
            openURL = [ProxomoApi serializeURL:loginURL withParams:params];
            NSLog(@"Opening: %@",openURL);
            didOpenOtherApp = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openURL]];
        }
        
        if (doSafariAuth && !didOpenOtherApp) {
            //application_id={applicationid}&display_type=page&response_url={response_url}&auth_token={auth_token}
            [params setValue:@"page" forKey:@"display_type"];
            [params setValue:@"http://developer.proxomo.com" forKey:@"response_url"];
            
            openURL = [ProxomoApi serializeURL:loginURL withParams:params];
            didOpenOtherApp = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openURL]];
        }
    }
*/
    
    if (!didOpenOtherApp) {
        [params setValue:@"mobile" forKey:@"display_type"];
        [params removeObjectForKey:@"response_url"];
        openURL = [ProxomoApi serializeURL:loginURL withParams:params];
        NSLog(@"Opening: %@",openURL);
        loginDialogView = [[AuthorizeDialog alloc] initWithURL:loginURL loginParams:params appDelegate:self];
        [loginDialogView expose];
    }
    
}

@end
