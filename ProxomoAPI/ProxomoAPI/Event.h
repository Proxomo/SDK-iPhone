//
//  Event.h
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "Person.h"
#import "ProxomoList.h"

typedef enum {
    SECRET_EVENT = 0,
    CLOSED_EVENT = 1,
    OPEN_EVENT = 2
} enumEventPrivacy;

typedef enum {
    UPCOMING = 0,
    COMPLETE = 1,
    CANCELED = 2
} enumEventStatus;

@interface Event : ProxomoObject {
    NSString *EventName;
    NSString *Description;
    NSString *EventType;
    enumEventPrivacy Privacy;
    enumEventStatus Status;
    NSDate *StartTime;
    NSDate *EndTime;
    NSDate *LastUpdate;
    NSInteger MaxParticipants;
    NSInteger MinParticipants;
    NSString *ImageUrl;
    NSString *Notes;
    NSString *PersonID;
    NSString *PersonName;
    NSArray *appData;
    ProxomoList *_appData;
    
    // Location Info
    NSString *Address1;
    NSString *Address2;
    NSString *City;
    NSString *State;
    NSString *Zip;
    NSString *CountryName;
    NSString *CountryCode; 
    NSString *LocationID;
    NSNumber *Latitude;
    NSNumber *Longitude;

}

@property (nonatomic, strong) NSString *EventName;
@property (nonatomic, strong) NSString *Description;
@property (nonatomic, strong) NSString *EventType;
@property (nonatomic) enumEventPrivacy Privacy;
@property (nonatomic) enumEventStatus Status;
@property (nonatomic, strong) NSDate   *StartTime;
@property (nonatomic, strong) NSDate   *EndTime;
@property (nonatomic, strong) NSDate   *LastUpdate;
@property (nonatomic) NSInteger MaxParticpants;
@property (nonatomic) NSInteger MinParticipants;
@property (nonatomic, strong) NSString *ImageUrl;
@property (nonatomic, strong) NSString *Notes;
@property (nonatomic, strong) NSString *PersonID;
@property (nonatomic, strong) NSString *PersonName;
@property (nonatomic, strong) NSArray *appData;

// Location Properties
@property (nonatomic, strong) NSString *LocationID;
@property (nonatomic, strong) NSNumber *Latitude;
@property (nonatomic, strong) NSNumber *Longitude;
@property (nonatomic, strong) NSString *Address1;
@property (nonatomic, strong) NSString *Address2;
@property (nonatomic, strong) NSString *City;
@property (nonatomic, strong) NSString *State;
@property (nonatomic, strong) NSString *Zip;
@property (nonatomic, strong) NSString *CountryName;
@property (nonatomic, strong) NSString *CountryCode;


-(NSArray*) searchByDistance:(double)miles fromLatitude:(double)latitude fromLongitude:(double)longitude startTime:(NSDate*)start endTime:(NSDate*)end apiContext:(id)context useAsync:(BOOL)useAsync; 

-(NSArray*) searchByPerson:(Person*)person startTime:(NSDate*)start endTime:(NSDate*)end  apiContext:(id)context useAsync:(BOOL)useAsync; 

@end
