//
//  ProxomoApi.m
//  ProxomoApi
//
//  Created by Fred Crable on 11/23/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "ProxomoApi.h"
#import "ProxomoObject+Proxomo.h"
#import "ProxomoList+Proxomo.h"
#import "Proxomo.h"

//#define __TRACE_REST
#define __TRACE_API
//#define __TRACE_DATA

#define kBaseURL @"https://service.proxomo.com/v09/"
#define kBaseJSON @"json"

@implementation ProxomoApi

@synthesize apiStatus;
@synthesize apiKey;
@synthesize applicationId;
@synthesize accessToken;
@synthesize apiVersion;
@synthesize appDelegate;

-(void)initData {
    accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    expires = [[NSUserDefaults standardUserDefaults] objectForKey:@"expires"];
    
    responseData = [[NSMutableDictionary alloc] init];
    responseDelegate = [[NSMutableDictionary alloc] init];
    responses = [[NSMutableDictionary alloc] init];
    requests = [[NSMutableDictionary alloc] init];
    
    encode_url_table = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"%24", @"$",
                         @"%26", @"&", 
                         @"%2B", @"+",
                         @"%2C", @",",
                         @"%2F", @"/",
                         @"%3A", @":",
                         @"%3B", @";",
                         @"%3D", @"=",
                         @"%3F", @"?",
                         @"%40", @"@",
                         @"%20", @" ",
                         @"%22", @"\"",
                         @"%3C", @"<",
                         @"%3E", @">",
                         @"%23", @"#",
                         @"%7B", @"{",
                         @"%7D", @"}",
                         @"%7C", @"|",
                         @"%5C", @"\\",
                         @"%5E", @"^",
                         @"%7E", @"~",
                         @"%5B", @"[",
                         @"%5D", @"]",
                         @"%60", @"`",
                         nil];
    numAsyncPending = 0;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (id) initWithKey:(NSString *)appKey appID:(NSString *)appID {
    self = [super init];
    if(self){
        apiKey = appKey;
        applicationId = appID;
        [self initData];
        [self checkLogin:nil];
    }
    return self;
}

- (id) initWithKey:(NSString *)appKey appID:(NSString *)appID andDelegate:(id)delegate{
    self = [super init];
    if(self){
        apiKey = appKey;
        applicationId = appID;
        appDelegate = delegate;
        [self initData];
        [self checkLogin:delegate];
    }
    return self;
}

- (BOOL)loginApi:(id <ProxomoApiDelegate>) requestDelegate {
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    NSString *urlstring= [kBaseURL stringByAppendingString:@"%@/security/accesstoken/get?applicationid=%@&proxomoAPIKey=%@"];
    // @"https://service.proxomo.com/v09/json/security/accesstoken/get?applicationid=%@&proxomoAPIKey=%@";
 
     
    if(apiKey == nil || applicationId == nil){
        NSLog(@"application ID is not set!");
        if(requestDelegate){
            [requestDelegate handleError:nil requestType:GET responseCode:410 responseStatus:@"Invalid Application"];
        }
        return NO;
    }
    
    NSString *f_urlstring= [NSString stringWithFormat:urlstring, kBaseJSON, [applicationId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[apiKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setURL:[NSURL URLWithString:f_urlstring]];
    [urlRequest setHTTPMethod:@"GET"]; 
    NSURLResponse *response; 
    NSError *error;
    NSData * urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSInteger responseCode = [httpResponse statusCode];
    
    if(urlData == nil || responseCode != 200){
#ifdef __TRACE_REST
        NSLog(@"%@ %d %@",[response URL],[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
#endif
        if(requestDelegate){
            [requestDelegate handleError:urlData requestType:GET responseCode:[httpResponse statusCode] responseStatus:[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]];
        }
        return NO;
    }
#ifdef __TRACE_API
    NSString *urlString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"login response %@",urlString);
#endif
    
    // parse and save the access token
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&error];    
    accessToken = [dict objectForKey:@"AccessToken"];
    expires = [dict objectForKey:@"Expires"];
#ifdef __TRACE_API
    NSLog(@"accesstoken string %@",accessToken);
    NSLog(@"expires %@",[NSDate dateWithTimeIntervalSince1970:[expires doubleValue]]);
#endif
    
    // save our access token and expiry time
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:expires forKey:@"expires"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

- (BOOL) checkLogin:(id <ProxomoApiDelegate>) delegate {
    bool isExpired = YES;
    // check expiration date of accesstoken first
    // do implicit login
    if([expires doubleValue]<=[[NSDate date] timeIntervalSince1970]){
        isExpired = YES;
    } else {
        isExpired = NO;
    }
    if (accessToken == nil || isExpired) {
        if([self loginApi:delegate] == NO)
            return NO;
    }
    return YES;
}

-(BOOL)isAsyncPending{
    return (numAsyncPending!=0);
}

+ (NSString*)serializeURL:(NSString *)baseUrl
                   withParams:(NSDictionary *)params {
    
    NSURL* parsedURL = [NSURL URLWithString:baseUrl];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator]) {
        
        
        NSString* escaped_value = (__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(
                              NULL, /* allocator */
                              (__bridge CFStringRef)[params objectForKey:key],
                              NULL, /* charactersToLeaveUnescaped */
                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                              kCFStringEncodingUTF8);
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", baseUrl, queryPrefix, query];
}


@end
