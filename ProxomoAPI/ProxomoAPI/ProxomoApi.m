//
//  ProxomoApi.m
//  ProxomoApi
//
//  Created by Fred Crable on 11/23/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "Proxomo.h"
#import "SBJson.h"

// uncomment these for tracing HTML and API calls
#define __TRACE_REST
//#define __TRACE_API
#define __TRACE_DATA

#define HTTP405_NOTALLOWED 405
#define kBaseURL @"https://service.proxomo.com/v09"
#define kBaseJSON @"json"

@implementation ProxomoApi

@synthesize apiStatus;
@synthesize apiKey;
@synthesize applicationId;
@synthesize accessToken;
@synthesize apiVersion;
@synthesize appDelegate;
@synthesize userContext;

NSDictionary *encode_url_table = nil;

-(void)initData {
    accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"proxomo_accessToken"];
    expires = [[NSUserDefaults standardUserDefaults] objectForKey:@"proxomo_expires"];
    
    responseData = [[NSMutableDictionary alloc] init];
    responseDelegate = [[NSMutableDictionary alloc] init];
    responses = [[NSMutableDictionary alloc] init];
    requests = [[NSMutableDictionary alloc] init];
    
    if(!encode_url_table) {
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
    }
    numAsyncPending = 0;
    isInAsyncMode = false;
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

- (id) initWithKey:(NSString *)appKey appID:(NSString *)appID delegate:(id)delegate{
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
-(void) setAsync:(BOOL)isAsync{
    isInAsyncMode = isAsync;
}

- (BOOL)loginApi:(id <ProxomoApiDelegate>) requestDelegate {
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    NSString *urlstring= [NSString stringWithFormat:@"%@/%@/security/accesstoken/get",
                          kBaseURL, kBaseJSON];
     
    if(apiKey == nil || applicationId == nil){
        NSLog(@"application ID is not set!");
        if(requestDelegate){
            [requestDelegate handleError:nil requestType:GET responseCode:410 responseStatus:@"Invalid Application"];
        }
        return NO;
    }
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:apiKey, @"proxomoAPIKey",
                            applicationId, @"applicationid", nil];
    NSString *f_urlstring= [ProxomoApi serializeURL:urlstring withParams:params];
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
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"proxomo_accessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:expires forKey:@"proxomo_expires"];
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
    //isExpired = YES; // TEST FORCE
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

#pragma mark - Communications Handler

- (void)_updateStatus:(NSURLConnection*)connection status:(NSString *)statusString
{
    if(statusString != nil){
        apiStatus = statusString;
#ifdef __TRACE_API
        NSLog(@"status: %@", statusString);
#endif
    }
}

- (void)_receiveDidStart:(NSURLConnection *)connection delegate:(id)requestDelegate
{
#ifdef __TRACE_REST
    [self _updateStatus:connection status:@"Receiving"];
#endif
    NSMutableData *data;
    
    data = [responseData objectForKey:connection];
    
    if(data != nil && [data length] > 0){
        [data setLength:0];
    }else if(data == nil){
        data = [NSMutableData data];
        NSNumber *connectionHash = [NSNumber numberWithInteger:[connection hash]];
        [responseData setObject:data forKey:connectionHash];
    }
}

-(NSString *)lastError{
    return lastError;
}

- (void)_receiveDidStopWithStatus:(NSURLConnection *)connection code:(NSInteger)responseCode status:(NSString *)statusString
{
    NSNumber *connectionHash = [NSNumber numberWithInteger:[connection hash]];    
    id <ProxomoApiDelegate> delegate = [responseDelegate objectForKey:connectionHash];
    NSMutableData *data = [responseData objectForKey:connectionHash];
    NSNumber *request = [requests objectForKey:connectionHash];
    
    if (statusString == nil) {
        statusString = @"Importing URL";
    }
    [self _updateStatus:connection status:statusString];
    
    if(delegate != nil){
        if(responseCode == 200)
            [delegate handleResponse:data requestType:[request intValue] responseCode:responseCode responseStatus:statusString];
        else
            [delegate handleError:data requestType:[request intValue] responseCode:responseCode responseStatus:statusString];
    }
    lastError = statusString;
    [responseData removeObjectForKey:connectionHash];
    [responseDelegate removeObjectForKey:connectionHash];
    [requests removeObjectForKey:connectionHash];
}

-(void) _logJar {
    NSHTTPCookieStorage *jar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSEnumerator*   enumerator;
    NSHTTPCookie*   cookie;
    enumerator = [[jar cookies] objectEnumerator];
    NSLog(@"There are %d Cookies in the jar.",[[jar cookies] count]);
    while ((cookie = [enumerator nextObject])) {
        NSLog(@"Name: %@, Value: %@, Expires: %@",
              [cookie name],
              [cookie value],
              [[cookie expiresDate] description]);
    }
}

+(NSString *) htmlEncodeString:(NSString *)input{
    NSString *replace;
    // @"%" --> @"%25" // do this 1st!
    if([input isKindOfClass:[NSNull class]] || [input isEqualToString:@""]) return nil;
    input = [input stringByReplacingOccurrencesOfString:@"%" withString:@"%25"];
    for (NSString *find in encode_url_table) {
        replace = [encode_url_table objectForKey:find];
        input = [input stringByReplacingOccurrencesOfString:find withString:replace];
    }
    return input;
}

-(NSString *)getPathForObject:(ProxomoObject*)obj forRequestType:(enumRequestType)requestType {
    if(obj){
        return [obj objectPath:requestType];
    }else{
        return @"";
    }
}

-(NSString *)getUrlForRequest:(ProxomoObject*)obj forRequestType:(enumRequestType)requestType{
    return [NSString stringWithFormat:@"%@", [self getPathForObject:obj forRequestType:requestType]];
}

- (NSString *)stringForRequestType:(enumRequestType)method{
    NSString *methodString = @"GET";
    
    switch (method) {
        case GET:
            methodString = @"GET";
            break;
        case POST:
            methodString = @"POST";
            break;
        case PUT:
            methodString = @"PUT";
            break;
        case DELETE:
            methodString = @"DELETE";
            break;
        default:
            break;
    }
    return methodString;
}

- (NSMutableURLRequest*)createRequestUrl:(NSString *)path 
                                  method:(enumRequestType)method 
                                  params:(NSDictionary*)params 
                                  delegate:(id)requestDelegate
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",kBaseURL, kBaseJSON, path];
    BOOL first = YES;
    if(params){
        for (NSString *param in params) {
            if(first){
                urlString = [urlString stringByAppendingString:@"?"];
                first = NO;
            }else{
                urlString = [urlString stringByAppendingString:@"&"];
            }
            urlString = [urlString stringByAppendingFormat:@"%@=%@",
                   param, [ProxomoApi htmlEncodeString:[params objectForKey:param]]];
        }
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = nil;
    
#ifdef __TRACE_REST
    NSString *methodName = [self stringForRequestType:method];
    NSLog(@"%@:%@",methodName, url);
#endif
    
    urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    if (method == POST || method == PUT) {
        if(requestDelegate){
            SBJsonWriter *writer = [[SBJsonWriter alloc] init];
            NSString *jsonBody = [writer stringWithObject:requestDelegate];
            if(jsonBody){
#ifdef __TRACE_DATA
                NSLog(@"%@\n",jsonBody);
#endif
                [urlRequest setHTTPBody:[jsonBody dataUsingEncoding:NSUTF8StringEncoding]];        
            }
        }
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    [urlRequest setHTTPMethod:[self stringForRequestType:method]];
    [urlRequest setValue:accessToken forHTTPHeaderField:@"Authorization"];
    return urlRequest;
}

-(void) makeRestRequest:(NSString*)path method:(enumRequestType)method params:(NSDictionary*)params delegate:(id <ProxomoApiDelegate>)requestDelegate
{
    if(![self checkLogin:requestDelegate]) return;
    
    NSMutableURLRequest *urlRequest = [self createRequestUrl:path method:method params:params delegate:requestDelegate];
    
    if(isInAsyncMode){
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        if(connection != nil){
            numAsyncPending++;
            NSNumber *connectionHash = [NSNumber numberWithInteger:[connection hash]];
            [requests setObject:[NSNumber numberWithInt:method] forKey:connectionHash];
            [responseDelegate setObject:requestDelegate forKey:connectionHash];
            [self _receiveDidStart:connection delegate:requestDelegate];
        } else if(requestDelegate) {
            [requestDelegate handleError:nil requestType:method responseCode:0 responseStatus:@"Failed to initialize connection"];
        }
    }else{
        NSURLResponse *response; 
        NSError *error;
        NSData * urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger responseCode = [httpResponse statusCode];
#ifdef __TRACE_REST
        NSLog(@"%@ %d %@",[response URL],[httpResponse statusCode],
              [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
#endif
        if(urlData == nil || responseCode != 200){
            if(requestDelegate){
                [requestDelegate handleError:urlData requestType:method responseCode:[httpResponse statusCode] responseStatus:[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]];
            }
        }else{
#ifdef __TRACE_DATA
            NSString* newStr = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(@"JSON %@ Result:\n%@",[self stringForRequestType:method], newStr);
#endif
            if(requestDelegate){
                [requestDelegate handleResponse:urlData requestType:method responseCode:responseCode responseStatus:[NSHTTPURLResponse localizedStringForStatusCode:responseCode]];
            }
        }
    }
}

#pragma NSURLRequest delegate

/*
 Disable caching so that each time we run this app we are starting with a clean slate.
 */
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection 
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse 
{
    return nil;
}

- (BOOL)connection:(NSURLConnection *)connection 
canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace 
{
#ifdef __TRACE_API
    NSLog(@"Checking protection space %@ %@ %@", connection, [protectionSpace realm], protectionSpace.authenticationMethod);
#endif
    if([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
#ifdef __TRACE_API
        NSLog(@"Can Auth Secure Requestes!");
#endif
        return YES;
    }
    NSLog(@"Cannot Auth!");
    return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
#ifdef __TRACE_API
        NSLog(@"Trust Challenge Requested!");
#endif
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
        
    }
    else if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic])
    {
        NSLog(@"Authentication Failure!");
        [self _receiveDidStopWithStatus:connection code:404 status:@"Login Challenge Failure"];
    }
}

// Called when a chunk of data has been downloaded.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
#ifdef __TRACE_DATA
    NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"JSON Result:\n%@", newStr);
#endif
    NSMutableData *requestData = nil;
    
    NSNumber *connectionHash = [NSNumber numberWithInteger:[connection hash]];
    requestData = [responseData objectForKey:connectionHash];
    [requestData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // cast the response to NSHTTPURLResponse so we can look for 404 etc
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
#ifdef __TRACE_API
    NSLog(@"%@ %d %@",[response URL],[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
#endif
    NSNumber *connectionHash = [NSNumber numberWithInteger:[connection hash]];
    
    [responses setObject:response forKey:connectionHash];
    if ([httpResponse statusCode] == 200) {
        // start recieving data
        NSMutableData *requestData = nil;
        requestData = [responseData objectForKey:connectionHash];
        [requestData setLength:0];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
#ifdef __TRACE_API
    NSLog(@"Connection Did Finish");
    [self _logJar];
#endif
    /*
     * Start to fill up the data array with objects
     */
    NSNumber *connectionHash = [NSNumber numberWithInteger:[connection hash]];
    NSHTTPURLResponse *response = [responses objectForKey:connectionHash];
    
    if (connection) {
        numAsyncPending--;
    }
    [self _receiveDidStopWithStatus:connection code:[response statusCode] status:@"Connection Did Finish"];
    [responses removeObjectForKey:connectionHash];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed! Error - %@", error);
    [self _receiveDidStopWithStatus:connection code:400 status:[error localizedDescription]];
}

#pragma mark - CRUD

-(BOOL) makeObjRequest:(enumRequestType)method forObject:(id)object inObject:(id)path {
    NSString *url, *ID;
    
    if(path){
        [path setApiContext:self];
        if([object objectType] == FRIEND_TYPE){
            url = [self getUrlForRequest:object forRequestType:method];
            ID = [ProxomoApi htmlEncodeString:[path ID]];
            if (!ID) return false;
            url = [url stringByAppendingFormat:@"/%@", ID];
        }else if([object objectType] == APPFRIEND_TYPE){
            url = [self getUrlForRequest:object forRequestType:method];
            ID = [ProxomoApi htmlEncodeString:[path ID]];
            if (!ID) return false;
            url = [url stringByAppendingFormat:@"/%@/socialnetwork/0", ID];
        }else if([object objectType] == SOCIALNETFRIEND_TYPE){
            url = [self getUrlForRequest:object forRequestType:method];
            ID = [ProxomoApi htmlEncodeString:[path ID]];
            if (!ID) return false;
            url = [url stringByAppendingFormat:@"/%@/socialnetwork/0", ID];
        }else if([object objectType] == SOCIALNETWORK_INFO_TYPE){
            url = [self getUrlForRequest:object forRequestType:method];
            ID = [ProxomoApi htmlEncodeString:[path ID]];
            if (!ID) return false;
            url = [url stringByAppendingFormat:@"/%@/socialnetworkinfo/socialnetwork/0", ID];
        }else{
            url = [self getUrlForRequest:path forRequestType:method];
            ID = [ProxomoApi htmlEncodeString:[path ID]];
            if (!ID) return false;
            url = [url stringByAppendingFormat:@"/%@/%@", ID, [self getPathForObject:object forRequestType:method]];
        }
    }else{
        url = [self getUrlForRequest:object forRequestType:method];
    }
    
    if([object isKindOfClass:[ProxomoList class]]){
        // Lists needed the S on the end
        switch ([object objectType]) {
            case LOCATION_TYPE:
            case EVENTCOMMENT_TYPE:
            case PERSON_LOGIN_TYPE:
                url = [url stringByAppendingString:@"s"];
                break;
            default:
                break;
        }
    }else if(method != POST && method != PUT){
        ID = [ProxomoApi htmlEncodeString:[object ID]];
        if (!ID || [ID isEqualToString:@""] ) return false;
        url = [url stringByAppendingFormat:@"/%@", ID];
    }
    
    [object setApiContext:self];
    if ([object appDelegate] == nil) {
        [object setAppDelegate:appDelegate];
    }
    [self makeRestRequest:url method:method params:nil delegate:object];
    return true;
}

#pragma mark - CRUD


-(void) Add:(ProxomoObject*)object inObject:(id)path {
    [self makeObjRequest:POST forObject:object inObject:path];
}

-(void) Update:(ProxomoObject*)object inObject:(id)path {
    [self makeObjRequest:PUT forObject:object inObject:path];
}

-(void) Delete:(ProxomoObject*)object inObject:(id)path {
    [self makeObjRequest:DELETE forObject:object inObject:path];
}
-(void) Get:(ProxomoObject*)object inObject:(id)path {
    [self makeObjRequest:GET forObject:object inObject:path];
}

#pragma mark - Lists


-(void)GetAll:(ProxomoList*)proxomoList getType:(enumObjectType)type inObject:(id)path {
    [proxomoList setListType:type];
    [self makeObjRequest:GET forObject:proxomoList inObject:path];
}


/*
-(void) Query:(id)proxomoList searchUrl:(NSString*)url queryParams:(NSDictionary*)query {
    [proxomoList setApiContext:self];
    [self makeRequest:url method:GET params:query delegate:proxomoList];
}
 */

-(void) Search:(ProxomoList*)proxomoList searchUrl:(NSString*)url searchUri:(NSString*)uri withParams:(NSDictionary*)params forListType:(enumObjectType)objType inObject:(id)path {
    
    [proxomoList setListType:objType];
    [proxomoList setApiContext:self];    
    if(uri){
        url = [NSString stringWithFormat:@"%@%@/%@", 
               [self getUrlForRequest:proxomoList forRequestType:GET],  
               url, 
               [ProxomoApi htmlEncodeString:uri]];
    }else{
        url = [NSString stringWithFormat:@"%@%@", 
               [self getUrlForRequest:proxomoList forRequestType:GET],  
               url];
    }

    if (appDelegate && ![proxomoList appDelegate]) 
        proxomoList.appDelegate = appDelegate;
    [self makeRestRequest:url method:GET params:params delegate:proxomoList];
}

-(void) GetByUrl:(ProxomoObject*)obj searchUrl:(NSString*)url searchUri:(NSString*)uri objectType:(enumObjectType)objType {
    url = [NSString stringWithFormat:@"%@%@/%@", [self getUrlForRequest:obj forRequestType:GET],  url, [ProxomoApi htmlEncodeString:uri]];
    
    if (appDelegate && ![obj appDelegate]) [obj setAppDelegate:appDelegate];
    [obj setApiContext:self];
    [self makeRestRequest:url method:GET params:nil delegate:obj];
}



@end
