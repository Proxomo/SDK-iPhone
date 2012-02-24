//
//  CustomData.h
//  ProxomoAPI
//
//  Created by Fred Crable on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProxomoObject.h"

@interface CustomData : ProxomoObject {
    NSString *TableName;
    NSDate *TimeStamp;
}

@property (nonatomic, strong) NSString *TableName;
@property (nonatomic, strong) NSDate *TimeStamp;

-(NSArray*)appData;

@end
