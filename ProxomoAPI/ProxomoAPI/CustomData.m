//
//  CustomData.m
//  ProxomoAPI
//
//  Created by Fred Crable on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomData.h"

@implementation CustomData
@synthesize TableName;
@synthesize TimeStamp;
@synthesize _searching;

-(id)init {
    self = [super init];
    if(self){
        _searching = NO;
        self.TableName = @"CUSTOMDATA";
    }
    return self;
}

-(enumObjectType) objectType {
    return CUSTOMDATA_TYPE;
}

-(NSString *) objectPath:(enumRequestType)requestType {
    if(requestType==GET||requestType==DELETE){
        if(_searching){
            return @"customdata/search";
        }else{
            return [NSString stringWithFormat:@"customdata/table/%@",
                    [ProxomoApi htmlEncodeString:TableName]];
        }
    }
    return @"customdata";
}

-(NSArray*)appData{
    NSArray *appData;
    return appData;
}

-(NSString *) description {
    return [NSString stringWithFormat:@"%@:%@", TableName, ID];
}

-(ProxomoList*)Search:(NSString *)query apiContext:(ProxomoApi *)context {
    _apiContext = context;
    ProxomoList *retVal = [[ProxomoList alloc] init];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:query, @"q", nil];
    
    retVal.listType = CUSTOMDATA_TYPE;
    retVal.appDelegate = self.appDelegate;
    retVal._clazz = [self class];
    [context Search:retVal searchUrl:@"/table" searchUri:TableName withParams:params forListType:CUSTOMDATA_TYPE inObject:nil];
    return retVal;
}

@end
