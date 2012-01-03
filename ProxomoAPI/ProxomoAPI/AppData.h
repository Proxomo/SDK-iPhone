//
//  AppData.h
//  PROXOMO
//
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProxomoObject.h"
#import "ProxomoList.h"

@interface AppData : ProxomoObject {
    NSString *Key;
    NSString *Value;
    NSString *ObjectType;
}

@property (nonatomic, strong) NSString *Key;
@property (nonatomic, strong) NSString *Value;
@property (nonatomic, strong) NSString *ObjectType;

-(id)initWithValue:(NSString*)value forKey:(NSString*)key;
-(id)initWithValue:(NSString*)value forKey:(NSString*)key objectType:(NSString*)objectType;
-(id)initWithValue:(NSString*)value forKey:(NSString*)key objectType:(NSString*)objectType proxomoId:(NSString*)proxomoId;

+(void)getAllInContext:(id)context intoList:(ProxomoList*)proxomoList useAsync:(BOOL)useAsync;
+(void)searchInContext:(id)context forObjectType:(NSString*)objectType intoList:(ProxomoList*)proxomoList useAsync:(BOOL)useAsync;

@end
