//
//  PROXOMO_Events.h
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 CreativeGurus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PROXOMO_API.h"

@interface PROXOMO_Events : PROXOMO_API {
    
}
-(void) Event_Add:(NSObject*)object;
-(void) Event_Get:(NSObject*)object;
-(void) Event_Update:(NSObject*)object;
-(void) Event_Comment_Add:(NSObject*)object;
-(void) Event_Comment_Delete:(NSObject*)object : (NSObject*) commentID;
-(void) Event_Comments_Get:(NSObject*)object;
-(void) Event_Comment_Update:(NSObject*)object;
-(void) Event_Participant_Invite:(NSObject*)object: (NSObject*) personID;
-(void) Event_Participants_Invite:(NSObject*)object: (NSObject*) personIDs;
-(void) Event_Request_Invitation:(NSObject*)object: (NSObject*) personID;
-(void) Event_Participants_Get:(NSObject*)object;
-(void) Event_Participant_Delete:(NSObject*)object : (NSObject*) eventParticipantID;
-(void) Event_RSVP:(NSObject*)object;
-(void) Events_Search:(NSObject*)object;
-(void) Events_Search_byPersonID:(NSObject*)object : (NSObject*) start :(NSObject *) end;
-(void) Event_AppData_Add:(NSObject*)object;
-(void) Event_AppData_Delete:(NSObject*)object : (NSObject*) appDataID;
-(void) Event_AppData_Get:(NSObject*)object : (NSObject *) appDataID;
-(void) Event_AppData_GetAll:(NSObject*)object;
-(void) Event_AppData_Update:(NSObject*)object;

@end
