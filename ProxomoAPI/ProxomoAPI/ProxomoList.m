//
//  ProxomoList.m
//  ProxomoAPI
//
//  Created by Fred Crable on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ProxomoApi+Proxomo.h"
#import "ProxomoList+Proxomo.h"
#import "ProxomoObject+Proxomo.h"
#import "AppData.h"

@implementation ProxomoList
@synthesize proxomoList;
@synthesize listType;

-(NSArray*)getList{
    return proxomoList;
}

+(BOOL)isSupported:(enumObjectType)listType{
    switch (listType) {
        case APPDATA_TYPE:
        case LOCATION_TYPE:
            return YES;
        default:
            return NO;
    }
    return NO;
}

-(void)GetAll:(ProxomoApi*)context getType:(enumObjectType)type{
    if([ProxomoList isSupported:type]){
        //[self setListType:type]; done in API
        [context GetAll:self getType:type];
    }else{
        [self handleError:nil requestType:GET responseCode:405 responseStatus:@"405 Method Not Allowed (Unsupported)"];
    }
}

-(BOOL)GetAll_Synchronous:(ProxomoApi*)context getType:(enumObjectType)getType{    
    if([ProxomoList isSupported:getType]){
        // [self setListType:getType]; done in API
        return [context GetAll_Synchronous:self getType:getType];
    }else{
        [self handleError:nil requestType:GET responseCode:405 responseStatus:@"unsupported"];
    }
    return false;
}



@end
