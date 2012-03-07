//
//  ProxomoList.m
//  ProxomoAPI
//
//  Created by Fred Crable on 11/29/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "Proxomo.h"
#import <objc/runtime.h>

@implementation ProxomoList
@synthesize proxomoList;
@synthesize listType;
@synthesize _clazz;

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
        case SOCIALNETWORK_INFO_TYPE:
        case APPFRIEND_TYPE:
        case PERSON_LOGIN_TYPE:
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
        context = [context _apiContext];
    }

    [context GetAll:self getType:type inObject:inObject];
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
        case APPFRIEND_TYPE:
            item = [[SocialNetworkPFriend alloc] init];
            break;
        case EVENT_TYPE:
            item = [[Event alloc] init];
            break;
        case EVENTCOMMENT_TYPE:
            item = [[EventComment alloc] init];
            break;
        case SOCIALNETWORK_INFO_TYPE:
            item = [[SocialNetworkInfo alloc] init];
            break;
        case PERSON_TYPE:
            item = [[Person alloc] init];
            break;
        case PERSON_LOGIN_TYPE:
            item = [[PersonLogin alloc] init];
            break;
        case CUSTOMDATA_TYPE:
            item = (ProxomoObject*)[[_clazz alloc] init];
            break;
        default:
            break;
    }
    [item setApiContext:_apiContext];
    if(jsonRepresentation){
        [item updateFromJsonRepresentation:jsonRepresentation];
    }
    return item;
}


-(NSString *) objectPath:(enumRequestType)requestType{
    ProxomoObject *obj;
    enumObjectType objType = listType;
    if (objType == SOCIALNETWORK_INFO_TYPE) {
        objType = PERSON_TYPE;
    }
    obj = [self createObjectOfType:objType fromJsonRepresentation:nil];
    if(obj && objType == CUSTOMDATA_TYPE){
        CustomData *cd = (CustomData*)obj;
        cd._searching = YES;
    }
    if(obj){
        return [obj objectPath:requestType];
    }else{
        return @"";
    }
}

-(void) updateFromJsonRepresentation:(id)jsonRepresentation {
    ProxomoObject *item;
    proxomoList = [[NSMutableArray alloc] init];
    for (NSDictionary *itemDictionary in jsonRepresentation) {
        item = [self createObjectOfType:listType fromJsonRepresentation:itemDictionary];
        if (item!=nil) [proxomoList addObject:item];
    }
}

@end
