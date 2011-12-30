//
//  ProxomoApi+Proxomo.m
//  ProxomoAPI
//
//  Created by Fred Crable on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ProxomoApi+Proxomo.h"
#import "ProxomoObject+Proxomo.h"
#import "ProxomoList+Proxomo.h"
#import "Proxomo.h"

// uncomment these for tracing HTML and API calls
#define __TRACE_REST
#define __TRACE_API
#define __TRACE_DATA

#define JSON_URL @"/v09/json/"
#define HTTP405_NOTALLOWED 405

@implementation ProxomoApi (Proxomo)

//
// TODO - Add other initializers for HTTPs and XML versus JSON
//        Also, needs initializer paths for end-user versus app authentication

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
        [delegate handleResponse:data requestType:[request intValue] responseCode:responseCode responseStatus:statusString];
    }
    
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

-(NSString *) htmlEncodeString:(NSString *)input{
    NSString *replace;
    // @"%" --> @"%25" // do this 1st!
    input = [input stringByReplacingOccurrencesOfString:@"%" withString:@"%25"];
    for (NSString *find in encode_url_table) {
        replace = [encode_url_table objectForKey:find];
        input = [input stringByReplacingOccurrencesOfString:find withString:replace];
    }
    return input;
}

-(NSString*)stringFromJsonRepresentation:(NSDictionary*)jsonRepresentation{
    NSString *jsonString = nil;
    if(jsonRepresentation){
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonRepresentation options:NSJSONWritingPrettyPrinted error:&error];
        if(error == nil && jsonData != nil){
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    return jsonString;
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

- (NSMutableURLRequest*)createRequestUrl:(NSString *)path method:(enumRequestType)method delegate:(id <ProxomoApiDelegate>) requestDelegate
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://service.proxomo.com%@",path]];;
    NSMutableURLRequest *urlRequest = nil;
    
#ifdef __TRACE_REST
    NSString *methodName;
    switch (method) {
        case POST:
            methodName = @"POST";
            break;
        case PUT:
            methodName = @"PUT";
            break;
        case DELETE:
            methodName = @"DELETE";
            break;
        default:
            methodName = @"GET";
            break;
    }
    NSLog(@"%@:%@",methodName, url);
#endif
    urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    if (method == POST || method == PUT) {
        if(requestDelegate){
            NSString *jsonBody = [self stringFromJsonRepresentation:[requestDelegate jsonRepresentation]];
#ifdef __TRACE_DATA
            NSLog(@"%@\n",jsonBody);
#endif
            [urlRequest setHTTPBody:[jsonBody dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    [urlRequest setHTTPMethod:[self stringForRequestType:method]];
    [urlRequest setValue:accessToken forHTTPHeaderField:@"Authorization"];
    return urlRequest;
}

- (void)makeAsyncRequest:(NSString*)path method:(enumRequestType)method delegate:(id <ProxomoApiDelegate>) requestDelegate 
{
    if(![self checkLogin:requestDelegate]) return;
    
    NSMutableURLRequest *urlRequest = [self createRequestUrl:path method:method delegate:requestDelegate];
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
}

- (BOOL)makeSyncRequest:(NSString*)path method:(enumRequestType)method delegate:(id <ProxomoApiDelegate>) requestDelegate 
{
    if(![self checkLogin:requestDelegate]) return false;
    
    NSMutableURLRequest *urlRequest = [self createRequestUrl:path method:method delegate:requestDelegate];
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
        return false;
    }
#ifdef __TRACE_DATA
    NSString* newStr = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"JSON %@ Result:\n%@",[self stringForRequestType:method], newStr);
#endif
    if(requestDelegate){
        [requestDelegate handleResponse:urlData requestType:method responseCode:responseCode responseStatus:[NSHTTPURLResponse localizedStringForStatusCode:responseCode]];
    }
    return true;
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
#ifdef __TRACE_REST
    NSLog(@"Checking protection space %@ %@ %@", connection, [protectionSpace realm], protectionSpace.authenticationMethod);
#endif
    if([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
#ifdef __TRACE_REST
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
#ifdef __TRACE_REST
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
#ifdef __TRACE_REST
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

-(NSString *)getUrlForRequest:(enumObjectType)objectType requestType:(enumRequestType)requestType{
    static NSString *baseURL = JSON_URL;
    
    switch(objectType){
        case APPDATA_TYPE:
            return [NSString stringWithFormat:@"%@appdata", baseURL];
        case FRIEND_TYPE:
            return [NSString stringWithFormat:@"%@friend", baseURL];
        case EVENT_TYPE:
            return [NSString stringWithFormat:@"%@event", baseURL];
        case GEOCODE_TYPE:
            return [NSString stringWithFormat:@"%geocode", baseURL];
        case LOCATION_TYPE:
            return [NSString stringWithFormat:@"%@location", baseURL];
        case NOTIFICATION_TYPE:
            return [NSString stringWithFormat:@"%@notification", baseURL];
        case PERSON_TYPE:
            return [NSString stringWithFormat:@"%@person", baseURL];
        default:
            return baseURL;
    }
    return baseURL;
}

#pragma mark - CRUD

-(void) Add:(ProxomoObject*)object {
    // let the object know it will receive a post response
    if(appDelegate) [object setAppDelegate:appDelegate];
    [self makeAsyncRequest:[self getUrlForRequest:[object objectType] requestType:POST] method:POST delegate:object];
}

-(BOOL) AddSynchronous:(ProxomoObject*)object {
    if(appDelegate) [object setAppDelegate:appDelegate];
    return [self makeSyncRequest:[self getUrlForRequest:[object objectType] requestType:POST] method:POST delegate:object];
}

-(void) Update:(ProxomoObject*)object{
    if(appDelegate) [object setAppDelegate:appDelegate];
    [self makeAsyncRequest:[self getUrlForRequest:[object objectType] requestType:PUT] method:PUT delegate:object];
}

-(BOOL) UpdateSynchronous:(ProxomoObject*)object{
    if(appDelegate) [object setAppDelegate:appDelegate];
    return [self makeSyncRequest:[self getUrlForRequest:[object objectType] requestType:PUT] method:PUT delegate:object];
}

-(void) Delete:(ProxomoObject*)object {
    if(appDelegate) [object setAppDelegate:appDelegate];
    NSString *ID = [self htmlEncodeString:[object ID]];
    [self makeAsyncRequest:[NSString stringWithFormat:@"%@/%@", [self getUrlForRequest:[object objectType] requestType:DELETE], ID] method:DELETE delegate:object];
}

-(BOOL) DeleteSynchronous:(NSString*)ID deleteType:(enumObjectType)type {
    ID = [self htmlEncodeString:ID];
    return [self makeSyncRequest:[NSString stringWithFormat:@"%@/%@", [self getUrlForRequest:type requestType:DELETE], ID] method:DELETE delegate:nil];
}

#pragma mark - Getters

- (ProxomoObject*)createObjFromData:(NSData *)data fromType:(enumObjectType)type {
    ProxomoObject *obj = nil;
    
    switch (type) {
        case APPDATA_TYPE:
            obj = [[AppData alloc] initFromJsonData:data];
            break;
        case FRIEND_TYPE:
            obj = [[Friend alloc] initFromJsonData:data];
            break;
        case EVENT_TYPE:
            obj = [[Event alloc] initFromJsonData:data];
            break;
        case GEOCODE_TYPE:
            obj = [[GeoCode alloc] initFromJsonData:data];
            break;
        case LOCATION_TYPE:
            obj = [[Location alloc] initFromJsonData:data];
            break;
        case NOTIFICATION_TYPE:
            obj = [[Notification alloc] initFromJsonData:data];
            break;
        case PERSON_TYPE:
            obj = [[Person alloc] initFromJsonData:data];
            break;
        default:
            break;
    }
    return obj;
}

-(void) Get:(ProxomoObject*)object {
    NSString *ID = [self htmlEncodeString:[object ID]];
    if(appDelegate) [object setAppDelegate:appDelegate];
    [self makeAsyncRequest:[NSString stringWithFormat:@"%@/%@", [self getUrlForRequest:[object objectType] requestType:GET], ID] method:GET delegate:object];
}

-(BOOL) GetSynchronous:(ProxomoObject*)object getType:(enumObjectType)type{
    NSString *ID = [self htmlEncodeString:[object ID]];
    if(appDelegate) [object setAppDelegate:appDelegate];
    return [self makeSyncRequest:[NSString stringWithFormat:@"%@/%@", [self getUrlForRequest:type requestType:GET], ID] method:GET delegate:object];
}

#pragma mark - Lists


-(void)GetAll:(ProxomoList*)proxomoList getType:(enumObjectType)type{
    if([ProxomoList isSupported:type]){
        [proxomoList setListType:type];
        if (appDelegate) [proxomoList setAppDelegate:appDelegate];
        [self makeAsyncRequest:[self getUrlForRequest:type requestType:GET] method:GET delegate:proxomoList];
    }else{
        [proxomoList handleError:nil requestType:GET responseCode:405 responseStatus:@"405 Method Not Allowed (Unsupported)"];
    }
}

-(BOOL)GetAll_Synchronous:(ProxomoList*)proxomoList getType:(enumObjectType)getType{
    if([ProxomoList isSupported:getType]){
        [proxomoList setListType:getType];
        if (appDelegate) [proxomoList setAppDelegate:appDelegate];
        return [self makeSyncRequest:[self getUrlForRequest:getType requestType:GET] method:GET delegate:proxomoList];
    }else{
        [proxomoList handleError:nil requestType:GET responseCode:405 responseStatus:@"405 Method Not Allowed (Unsupported)"];
    }
    return false;
}

-(void) Search:(ProxomoList*)proxomoList searchUrl:(NSString*)url searchUri:(NSString*)uri forListType:(enumObjectType)objType useAsync:(BOOL)async {
    
    url = [NSString stringWithFormat:@"%@%@/%@", [self getUrlForRequest:objType requestType:GET],  url, [self htmlEncodeString:uri]];
    [proxomoList setListType:objType];
    if (appDelegate) [proxomoList setAppDelegate:appDelegate];
    if(async){
        [self makeAsyncRequest:url method:GET delegate:proxomoList];
    }else{
        [self makeSyncRequest:url method:GET delegate:proxomoList];
    }
}


@end
