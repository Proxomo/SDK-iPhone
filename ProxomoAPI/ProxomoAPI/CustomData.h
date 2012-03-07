//
//  CustomData.h
//  ProxomoAPI
//
//  Created by Fred Crable on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProxomoObject.h"
#import "ProxomoList.h"

@interface CustomData : ProxomoObject {
    NSString *TableName;
    NSDate *TimeStamp;
    BOOL _searching;
}

@property (nonatomic, strong) NSString *TableName;
@property (nonatomic, strong) NSDate *TimeStamp;
@property (nonatomic) BOOL _searching;

-(ProxomoList*)Search:(NSString *)query apiContext:(ProxomoApi *)context;

@end
