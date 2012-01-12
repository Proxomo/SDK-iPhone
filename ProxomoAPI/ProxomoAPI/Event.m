//
//  Event.m
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize EventName;
@synthesize Description;
@synthesize EventType;
@synthesize Privacy;
@synthesize Status;
@synthesize ImageUrl;
@synthesize Notes;
@synthesize PersonID;
@synthesize PersonName;
@synthesize StartTime;
@synthesize EndTime;
@synthesize LastUpdate;
@synthesize MinParticipants;
@synthesize MaxParticpants;
@synthesize appData;

#pragma mark - JSON Data Support

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

/*
-(void) updateFromJsonRepresentation:(NSDictionary*)jsonRepresentation{
    if(jsonRepresentation){
        [super updateFromJsonRepresentation:jsonRepresentation];
        Description = [jsonRepresentation objectForKey:@"Description"];
         EventName = [jsonRepresentation objectForKey:@"EventName"];
        EventType = [jsonRepresentation objectForKey:@"EventType"];
        //Privacy = (enumEventPrivacy)[jsonRepresentation objectForKey:@"Privacy"];
        //Status = (enumEventPrivacy)[jsonRepresentation objectForKey:@"Status"];
        StartTime = [self getJSONDate:[jsonRepresentation objectForKey:@"StartTime"]];
        EndTime = [self getJSONDate:[jsonRepresentation objectForKey:@"EndTime"]];
        LastUpdate = [self getJSONDate:[jsonRepresentation objectForKey:@"LastUpdate"]];
        //MaxParticpants = [jsonRepresentation objectForKey:@"MaxParticpants"];
        //MinParticipants = [jsonRepresentation objectForKey:@"MinParticpants"];
        ImageUrl = [jsonRepresentation objectForKey:@"ImageURL"];
        Notes = [jsonRepresentation objectForKey:@"Notes"];
        PersonID = [jsonRepresentation objectForKey:@"PersonID"];
        PersonName = [jsonRepresentation objectForKey:@"PersonName"];
    }
}
 */

#pragma mark - API Delegate

-(enumObjectType) objectType{
    return EVENT_TYPE;
}

-(NSString *) objectPath{
    return @"event";
}


/*
-(void) handleError:(NSData*)response requestType:(enumRequestType)requestType responseCode:(NSInteger)code responseStatus:(NSString*) status{
    [super handleError:response requestType:requestType responseCode:code responseStatus:status];
}

-(void) handleResponse:(NSData *)response requestType:(enumRequestType)requestType  responseCode:(NSInteger)code responseStatus:(NSString *)status{
    if(requestType == POST){
        NSError *error;
        ID = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    }
    [super handleResponse:response requestType:requestType  responseCode:code responseStatus:status];
}
 */

@end
