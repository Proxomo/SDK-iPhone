//
//  ProxomoList.m
//  ProxomoAPI
//
//  Created by Fred Crable on 11/29/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "Proxomo.h"

@implementation ProxomoList
@synthesize proxomoList;
@synthesize listType;

-(NSArray*)arrayValue{
    return proxomoList;
}

+(BOOL)isSupported:(enumObjectType)listType {
    switch (listType) {
        case APPDATA_TYPE:
        case LOCATION_TYPE:
        case FRIEND_TYPE:
        case SOCIALNETFRIEND_TYPE:
        case EVENT_TYPE:
        case EVENTCOMMENT_TYPE:
            return YES;
        default:
            return NO;
    }
    return NO;
}

-(enumObjectType) objectType {
    return listType;
}

-(void)GetAll:(id)context getType:(enumObjectType)type{
    id inObject = nil;
    if(![ProxomoList isSupported:type]){
        [self handleError:nil requestType:GET responseCode:405 responseStatus:@"405 Method Not Allowed (Unsupported)"];
        return;
    }

    if(context && ![context isKindOfClass:[ProxomoApi class]]){
        inObject = context;
        _accessToken = [inObject getAccessToken];
        context = [context _apiContext];
    }

    [context GetAll:self getType:type inObject:inObject];
}

-(BOOL)GetAll_Synchronous:(id)context getType:(enumObjectType)type{    
    id inObject = nil;
    if(![ProxomoList isSupported:type]){
        return false;
    }
    
    if(![context isKindOfClass:[ProxomoApi class]]){
        inObject = context;
        _accessToken = [inObject getAccessToken];
        context = [context _apiContext];
    }
    
    return [context GetAll_Synchronous:self getType:type inObject:inObject];
}

-(ProxomoObject *) createObjectOfType:(enumObjectType)type fromJsonRepresentation:(NSDictionary*)jsonRepresentation {
    ProxomoObject *item;
    
    switch (type) {
        case APPDATA_TYPE:
            item = [[AppData alloc] init];
            break;
        case LOCATION_TYPE:
            item = [[Location alloc] init];
            break;
        case FRIEND_TYPE:
            item = [[Friend alloc] init];
            break;
        case SOCIALNETFRIEND_TYPE:
            item = [[SocialNetworkFriend alloc] init];
            break;
        case EVENT_TYPE:
            item = [[Event alloc] init];
            break;
        case EVENTCOMMENT_TYPE:
            item = [[EventComment alloc] init];
            break;
        default:
            break;
    }
    [item setApiContext:_apiContext];
    [item updateFromJsonRepresentation:jsonRepresentation];
    return item;
}

-(void) updateFromJsonRepresentation:(id)jsonRepresentation {
    ProxomoObject *item;
    proxomoList = [[NSMutableArray alloc] init];
    for (NSDictionary *itemDictionary in jsonRepresentation) {
        item = [self createObjectOfType:listType fromJsonRepresentation:itemDictionary];
        [proxomoList addObject:item];
    }
}

@end
