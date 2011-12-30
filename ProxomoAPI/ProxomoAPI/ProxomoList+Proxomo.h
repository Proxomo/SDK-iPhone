//
//  ProxomoList+Proxomo.h
//  ProxomoAPI
//
//  Created by Fred Crable on 11/30/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "ProxomoList.h"

@interface ProxomoList (Proxomo)

-(id)initWithRequest:(enumRequestType)reqType forObjectType:(enumObjectType)objType;
-(id)initWithJsonData:(NSData*)jsonData listType:(enumObjectType)type;

@end
