//
//  ProxomoList.h
//  ProxomoAPI
//
//  Created by Fred Crable on 11/29/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProxomoObject.h"

@interface ProxomoList : ProxomoObject {
    NSMutableArray *proxomoList;
    enumObjectType listType;
    Class _clazz; // for custom data
}

@property (nonatomic, strong) NSMutableArray *proxomoList;
@property (nonatomic) enumObjectType listType;
@property (nonatomic, assign) Class _clazz;

+(BOOL)isSupported:(enumObjectType)listType;
-(NSArray*)arrayValue;

/**
 gets all of the instances for given type
 uses the ProxomoList as the delegate call object
 */
-(void) GetAll:(id)apiContext getType:(enumObjectType)type;

// Delegate method override
-(void) updateFromJsonRepresentation:(id)jsonRepresentation;


@end
