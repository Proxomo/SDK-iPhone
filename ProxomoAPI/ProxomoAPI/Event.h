//
//  Event.h
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

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

@interface Event : Location {
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


@end
