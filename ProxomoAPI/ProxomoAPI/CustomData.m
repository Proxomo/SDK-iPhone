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

-(id)init {
    self = [super init];
    if(self){
        self.TableName = @"CUSTOMDATA";
    }
    return self;
}

-(enumObjectType) objectType {
    return CUSTOMDATA_TYPE;
}

-(NSString *) objectPath:(enumRequestType)requestType{
    if(requestType==GET||requestType==DELETE){
        return [NSString stringWithFormat:@"customdata/table/%@",TableName];
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

@end
