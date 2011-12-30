//
//  ProxomoList+Proxomo.m
//  ProxomoAPI
//
//  Created by Fred Crable on 11/30/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "ProxomoList+Proxomo.h"
#import "ProxomoObject+Proxomo.h"
#import "AppData.h"
#import "Location.h"

@implementation ProxomoList (Proxomo)

-(id)initWithRequest:(enumRequestType)reqType forObjectType:(enumObjectType)objType{
    self = [super init];
    if(self){
        listType = objType;
    }
    return self;
}

-(void)initFromJson: (NSData*)jsonData listType:(enumObjectType)type{
    NSError *error = nil;
    NSDictionary *jsonDictionary = nil;
    proxomoList = nil;   
    
    if ([jsonData length]==0) {
        return;
    }
    jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if(!jsonDictionary || error){
        NSLog(@"Error parsing json list: %@",[error localizedDescription]);
        return;
    }
    if(type == APPDATA_TYPE){
        AppData *appDataItem = nil;
        
        proxomoList = [[NSMutableArray alloc] init];
        for (NSDictionary *appDataDictionary in jsonDictionary) {
            appDataItem = [[AppData alloc] initFromJsonRepresentation:appDataDictionary];
            [proxomoList addObject:appDataItem];
        }
    } else if(type == LOCATION_TYPE){
        Location *locationItem = nil;
        
        proxomoList = [[NSMutableArray alloc] init];
        for (NSDictionary *appDataDictionary in jsonDictionary) {
            locationItem = [[Location alloc] initFromJsonRepresentation:appDataDictionary];
            [proxomoList addObject:locationItem];
        }
    }
}

-(id)initWithJsonData:(NSData*)jsonData listType:(enumObjectType)type{
    self = [super init];
    if(self){
        [self initFromJson:jsonData listType:type];
        self.listType = type;
    }
    return self;
}

-(void) handleError:(NSData*)response requestType:(enumRequestType)requestType responseCode:(NSInteger)code responseStatus:(NSString*) status{
    proxomoList = nil;
    [super handleError:response requestType:requestType responseCode:code responseStatus:status];
}

-(void) handleResponse:(NSData *)response requestType:(enumRequestType)requestType responseCode:(NSInteger)code responseStatus:(NSString *)status{
    [super handleResponse:response requestType:requestType responseCode:code responseStatus:status];
    if (code == 200) [self initFromJson:response listType:listType];
}


@end
