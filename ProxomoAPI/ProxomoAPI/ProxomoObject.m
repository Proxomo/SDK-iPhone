//
//  ProxomoObject.m
//  ProxomoAPI
//
//  Created by Fred Crable on 11/27/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "ProxomoObject.h"
#import "ProxomoList.h"
#import "Person.h"
#import "SBJson.h"
#import <objc/runtime.h>

@implementation ProxomoObject

@synthesize restResponse;
@synthesize ID;
@synthesize appDelegate;
@synthesize _apiContext;

-(id) init {
    self = [super init];
    if(self){
        appDelegate = nil;
    }
    return self;
}

-(id)initWithID:(NSString*)objectdId{
    self = [super init];
    if(self){
        [self setID:objectdId];
        appDelegate = nil;
    }
    return self;
}

-(enumObjectType) objectType{
    return GENERIC_TYPE;
}

-(NSString *) objectPath{
    return @"";
}


// adds the object, sets the ID in object
-(void) Add:(id)context  
{   
    if([context isKindOfClass:[ProxomoApi class]]){
        _apiContext = context;
        [_apiContext Add:self inObject:nil];
    }else{
        _apiContext = [context _apiContext];
        [_apiContext Add:self inObject:context];
    }
}

// @returns true == success, false == failure
-(BOOL) AddSynchronous:(id)context {
    if([context isKindOfClass:[ProxomoApi class]]){
        _apiContext = context;
        return [_apiContext AddSynchronous:self inObject:nil];
    }else{
        _apiContext = [context _apiContext];
       return [_apiContext AddSynchronous:self inObject:context];
    }
}

// updates or creates a single instance from object
// asynchronously updates or creates a single instance
// ID must be set in object
-(void) Update:(id)context{
    if([context isKindOfClass:[ProxomoApi class]]){
        _apiContext = context;
        [_apiContext Update:self inObject:nil];
    }else{
        _apiContext = [context _apiContext];
        [_apiContext Update:self inObject:context];
    }     
}

// @return true == success, false == failure
-(BOOL) UpdateSynchronous:(id)context{
    if([context isKindOfClass:[ProxomoApi class]]){
        _apiContext = context;
        return [_apiContext UpdateSynchronous:self inObject:nil];
    }else{
        _apiContext = [context _apiContext];
        return [_apiContext UpdateSynchronous:self inObject:context];
    }
}

// gets an instance by ID
// ID must be set in object
// updates and overwrites current properties
-(void) Get:(id)context{
    if([context isKindOfClass:[ProxomoApi class]]){
        _apiContext = context;
        [_apiContext Get:self inObject:nil];
    }else{
        _apiContext = [context _apiContext];
        [_apiContext Get:self inObject:context];
    }

    
}

// @returns id of new AppData instance
-(BOOL) GetSynchronous:(id)context{
    if([context isKindOfClass:[ProxomoApi class]]){
        _apiContext = context;
        return [_apiContext GetSynchronous:self inObject:nil];
    }else{
        _apiContext = [context _apiContext];
        return [_apiContext GetSynchronous:self inObject:context];
    }
}


// deletes a data instance by ID
// ID must be set in object
-(void) Delete:(id)context{
    if([context isKindOfClass:[ProxomoApi class]]){
        _apiContext = context;
        [_apiContext Delete:self inObject:nil];
    }else{
        _apiContext = [context _apiContext];
        [_apiContext Delete:self inObject:context];
    } 
}

// @returns true == success, false == failure
-(BOOL) DeleteSynchronous:(id)context{
    if([context isKindOfClass:[ProxomoApi class]]){
        _apiContext = context;
        return [_apiContext DeleteSynchronous:self inObject:nil];
    }else{
        _apiContext = [context _apiContext];
        return [_apiContext DeleteSynchronous:self inObject:context];
    }
}

#pragma mark - JSON Utilities

- (NSDate *) getJSONDate:(NSString *)dateString{
    NSString* header = @"/Date(";
    uint headerLength = [header length];
    
    NSString*  timestampString;
    
    NSScanner* scanner = [[NSScanner alloc] initWithString:dateString];
    [scanner setScanLocation:headerLength];
    [scanner scanUpToString:@")" intoString:&timestampString];
    
    NSCharacterSet* timezoneDelimiter = [NSCharacterSet characterSetWithCharactersInString:@"+-"];
    NSRange rangeOfTimezoneSymbol = [timestampString rangeOfCharacterFromSet:timezoneDelimiter];
    
    if (rangeOfTimezoneSymbol.length!=0) {
        scanner = [[NSScanner alloc] initWithString:timestampString];
        
        NSRange rangeOfFirstNumber;
        rangeOfFirstNumber.location = 0;
        rangeOfFirstNumber.length = rangeOfTimezoneSymbol.location;
        
        NSRange rangeOfSecondNumber;
        rangeOfSecondNumber.location = rangeOfTimezoneSymbol.location + 1;
        rangeOfSecondNumber.length = [timestampString length] - rangeOfSecondNumber.location;
        
        NSString* firstNumberString = [timestampString substringWithRange:rangeOfFirstNumber];
        //NSString* secondNumberString = [timestampString substringWithRange:rangeOfSecondNumber];
        
        unsigned long long firstNumber = [firstNumberString longLongValue];
        //uint secondNumber = [secondNumberString intValue];
        
        NSTimeInterval interval = firstNumber/1000;
        
        return [NSDate dateWithTimeIntervalSince1970:interval];
    }
    
    unsigned long long firstNumber = [timestampString longLongValue];
    NSTimeInterval interval = firstNumber/1000;
    
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

-(NSMutableDictionary*)proxyForJson{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    Class clazz = [self class];
    u_int count;
    
    Ivar* ivars = class_copyIvarList(clazz, &count);
    const char *ivarName, *typeEncoding;
    id ivarValue;
    char ivarType;
    ptrdiff_t offset;
    int ival = 0;
    long lval = 0;
    double tempDate;
    NSString *jsonDate;
    NSString *key;
    
    if (ID) [dict setValue:ID forKey:@"ID"]; // inherited do not appear in list?
    for (int i = 0; i < count ; i++)
    {
        ivarName = ivar_getName(ivars[i]);
        key = [NSString  stringWithCString:ivarName encoding:NSUTF8StringEncoding];
        typeEncoding = ivar_getTypeEncoding(ivars[i]);
        ivarType = typeEncoding[0];
        
        if (ivarName[0] == '_') {
            continue; // skip fields hidden by starting with _
        }
        
        switch (ivarType) {
            case '@':
                ivarValue = object_getIvar(self, ivars[i]);
                if(!ivarValue || [ivarValue isKindOfClass:[NSNull class]]){
                    //NSLog(@"Empty json value:%@",key);
                    continue;
                }
                if ([ivarValue isKindOfClass:[NSDate class]]) {
                    tempDate = [(NSDate*)ivarValue timeIntervalSince1970] * 1000;
                    jsonDate = [NSString stringWithFormat:@"/Date(%ld)/",tempDate];
                    [dict setValue:jsonDate forKey:key]; 
                }else{
                    [dict setValue:ivarValue forKey:key];
                }
                break;
            case 'i':
                offset = ivar_getOffset(ivars[i]);
                ival = *(int *)((__bridge void*)self + offset);
                [dict setValue:[NSNumber numberWithInteger:ival] forKey:key];
                break;
            case 'l':
                offset = ivar_getOffset(ivars[i]);
                lval = *(long *)((__bridge void*)self + offset);
                [dict setValue:[NSNumber numberWithLong:lval] forKey:key];
                break;
            default:
                NSLog(@"Invalid JSON Property Type %c",ivarType);
                break;
        }
    }
    free(ivars);
    
    return dict;
}

-(void) updateFromJsonRepresentation:(NSDictionary*)jsonRepresentation {
    if(!jsonRepresentation)
        return;
    
    if(![jsonRepresentation isKindOfClass:[NSDictionary class]]) 
        return;
    
    NSString *temp_id = [jsonRepresentation objectForKey:@"ID"];
    if(temp_id){
        // don't loose or overwrite a good ID
        ID = temp_id;
    }
    
    /*
     * Can this loop over Clazz variables - needs optimization
     */
    Class clazz = [self class];
    u_int count;
    
    Ivar* ivars = class_copyIvarList(clazz, &count);
    const char *ivarName, *typeEncoding;
    id ivarValue;
    char ivarType;
    ptrdiff_t offset;
    int ival = 0;
    long lval = 0;
    NSString *key;
    
    // inherited do not appear in list?
    // attempt to store map of ivar names to ivars to set using the json dictionary
    for (int i = 0; i < count ; i++){
        ivarName = ivar_getName(ivars[i]);
        key = [NSString  stringWithCString:ivarName encoding:NSUTF8StringEncoding];
        typeEncoding = ivar_getTypeEncoding(ivars[i]);
        ivarType = typeEncoding[0];
        
        if (ivarName[0] == '_') {
            continue; // skip fields hidden by starting with _
        }
        
        ivarValue = [jsonRepresentation objectForKey:key];
        if(!ivarValue || [ivarValue isKindOfClass:[NSNull class]]){
            //NSLog(@"Empty json key:%@",key);
            continue;
        }
        switch (ivarType) {
            case '@':
                if ([ivarValue isKindOfClass:[NSDate class]]) {
                    object_setIvar(self, ivars[i], [self getJSONDate:ivarValue]);
                }else if ([ivarValue isKindOfClass:[NSString class]]) {
                    object_setIvar(self, ivars[i], ivarValue);
                }else if ([ivarValue isKindOfClass:[NSNumber class]]) {
                    object_setIvar(self, ivars[i], ivarValue);
                }else{
                    NSLog(@"Invalid json type %s for %@",class_getName([ivarValue class]), key);
                }
                break;
            case 'i':
                offset = ivar_getOffset(ivars[i]);
                ival = 99; // todo convert json dictonary type to int
                *(int *)((__bridge void*)self + offset) = ival;
                break;
            case 'l':
                offset = ivar_getOffset(ivars[i]);
                lval = 99; // todo convert json dictonary type to int
                *(long *)((__bridge void*)self + offset) = lval;
                break;
            default:
                NSLog(@"Invalid JSON Property Type %c",ivarType);
                break;
        }
    }
    free(ivars);
}

-(void) updateFromJsonData:(NSData*)response {
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    
    if(error != nil){
        NSLog(@"Error reading JSON data %@", error);
    }else{
        [self updateFromJsonRepresentation:dict];
    }
}

-(id)initFromJsonData:(NSData *)jsonData{
    self = [super init];
    if(self){
        [self updateFromJsonData:jsonData];
    }
    return self;
}

-(id)initFromJsonRepresentation:(NSDictionary*)jsonRepresentation{
    self = [super init];
    if(self){
        [self updateFromJsonRepresentation:jsonRepresentation];
    }
    return self;
}

#pragma mark - API Delegate

-(void) handleResponse:(NSData*)response requestType:(enumRequestType)requestType responseCode:(NSInteger)code responseStatus:(NSString*) status{
    responseCode = code;
    restResponse = status;
    if(requestType == GET){
        [self updateFromJsonData:response];
    } else if (requestType == POST){
        NSError *error;
        NSString *id = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
        if(id != nil && error == nil){
            ID = id;
        }else{
            NSLog(@"Warning - invalid ID returned from server");
        }
    }
    
    if([appDelegate respondsToSelector:@selector(asyncObjectComplete:proxomoObject:)]){
        [appDelegate asyncObjectComplete:(responseCode==200) proxomoObject:self];
    }
    requestType = NONE;
}

-(void) handleError:(NSData*)response requestType:(enumRequestType)requestType responseCode:(NSInteger)code responseStatus:(NSString*) status{
    requestType = NONE;
    responseCode = code;
    restResponse = status;
    if([appDelegate respondsToSelector:@selector(asyncObjectComplete:proxomoObject:)]){
        [appDelegate asyncObjectComplete:FALSE proxomoObject:self];
    }
}


@end
