//
//  ProxomoList.h
//  ProxomoAPI
//
//  Created by Fred Crable on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProxomoApi.h"
#import "ProxomoObject.h"

@interface ProxomoList : ProxomoObject {
    NSMutableArray *proxomoList;
    enumObjectType listType;
}

@property (nonatomic, strong) NSMutableArray *proxomoList;
@property (nonatomic) enumObjectType listType;
+(BOOL)isSupported:(enumObjectType)listType;
-(NSArray*)getList;

/**
 gets all of the instances for given type
 uses the ProxomoList as the delegate call object
 */
-(void) GetAll:(id)apiContext getType:(enumObjectType)type;
/// @returns true on success, false if failure
-(BOOL) GetAll_Synchronous:(id)apiContext getType:(enumObjectType)getType;



@end
