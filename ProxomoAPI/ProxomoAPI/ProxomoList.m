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

-(NSArray*)getList{
    return proxomoList;
}

+(BOOL)isSupported:(enumObjectType)listType{
    switch (listType) {
        case APPDATA_TYPE:
        case LOCATION_TYPE:
        case FRIEND_TYPE:
        case SOCIALNETFRIEND_TYPE:
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

    if(![context isKindOfClass:[ProxomoApi class]]){
        inObject = context;
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
        context = [context _apiContext];
    }
    
    return [context GetAll_Synchronous:self getType:type inObject:inObject];
}

-(id) createObjectOfType:(enumObjectType)type{
    switch (type) {
        case APPDATA_TYPE:
            return [[AppData alloc] init];
            break;
        case LOCATION_TYPE:
            return [[Location alloc] init];
        case FRIEND_TYPE:
            return [[Friend alloc] init];
        case SOCIALNETFRIEND_TYPE:
            return [[SocialNetworkFriend alloc] init];
        default:
            break;
    }
    return nil;
}

-(void) updateFromJsonRepresentation:(NSDictionary*)jsonRepresentation {
    id item;
    proxomoList = [[NSMutableArray alloc] init];
    for (NSDictionary *locationDataDictionary in jsonRepresentation) {
        item = [self createObjectOfType:listType];
        [proxomoList addObject:item];
    }
}

@end
