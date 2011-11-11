//
//  PROXOMO_API.m
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 CreativeGurus. All rights reserved.
//

#import "PROXOMO_API.h"
#import "SBJson/SBJson.h"

@implementation PROXOMO_API
@synthesize apikey;
@synthesize applicationid;
@synthesize accessToken;
@synthesize delegate;

-(id)init {
    self = [super init];
    if (self) {
        accessToken = nil;
    }
    return self;
}

- (void)makeRequest:(NSString*)path parameters:(NSString*)parameters method:(NSString*)method {
    
    if (accessToken == nil) {
        NSString *urlstring=@"https://service.proxomo.com/v09/json/security/accesstoken/get?applicationid=%@&proxomoAPIKey=%@";
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];

        NSString *f_urlstring= [NSString stringWithFormat:urlstring,[applicationid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[apikey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [urlRequest setURL:[NSURL URLWithString:f_urlstring]];
        [urlRequest setHTTPMethod:@"GET"]; 
        NSURLResponse *response; 
        NSError *error;
        NSData * urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
        NSString *urlString = [[NSString alloc] initWithData:urlData 
                                                    encoding:NSUTF8StringEncoding];
        NSLog(@"url string %@",urlString);
        NSDictionary *dict = [urlString JSONValue];
        
        accessToken = [dict objectForKey:@"AccessToken"];
        NSLog(@"accesstoken string %@",accessToken);
        expires = [dict objectForKey:@"Expires"];
        NSLog(@"expires %@",expires);
    }    
    NSURL *myURL;
    if ([method isEqualToString:@"GET"] && parameters != nil && [parameters length] > 0) {
        NSString *urlString = [NSString stringWithFormat:@"https://service.proxomo.com%@?%@",path,parameters];
        myURL = [NSURL URLWithString:urlString];
        NSLog(@"URL GET string %@",urlString);
    } else{
        myURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://service.proxomo.com%@",path]];        
    }
    
    NSLog(@"my url %@",myURL);
    request = [NSMutableURLRequest requestWithURL:myURL
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:60];
    if ([method isEqualToString:@"POST"] || [method isEqualToString:@"DELETE"]) {
        NSLog(@"Post body is %@",parameters);
        [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }

    [request setHTTPMethod:method];
    [request setValue:accessToken forHTTPHeaderField:@"Authorization"];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Show error message
    NSLog(@"error %@", [error localizedDescription]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Use responseData
    NSString * receivedString = [[NSString alloc] initWithData:responseData 
                                                      encoding:NSUTF8StringEncoding];
    NSLog(@"string %@",receivedString);
    [self handleRequest:receivedString];
}
- (void)handleRequest:(NSString *)response {
    //switch on [request URL] to get the delegate method to call
    //do this in the subclasses
}




@end
