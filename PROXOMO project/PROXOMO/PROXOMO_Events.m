//
//  PROXOMO_Events.m
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 CreativeGurus. All rights reserved.
//

#import "PROXOMO_Events.h"
#import "SBJson/SBJson.h"

@interface PROXOMO_Events()

@end

@implementation PROXOMO_Events

-(void) Event_Add:(NSObject*)object{
    [self makeRequest:@"/v09/json/event" parameters:[object JSONRepresentation] method:@"POST"];
}
-(void) Event_Get:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@",object ] parameters:@"" method:@"GET"];
}
-(void) Event_Update:(NSObject*)object{
    [self makeRequest:@"/v09/json/event" parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) Event_Comment_Add:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/comment",object ]  parameters:[object JSONRepresentation] method:@"POST"];
}
-(void) Event_Comment_Delete:(NSObject*)object : (NSObject*) commentID{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/comment/%@",object,commentID ]  parameters:[object JSONRepresentation] method:@"DELETE"];
}
-(void) Event_Comments_Get:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/comments",object ] parameters:@"" method:@"GET"];
}
-(void) Event_Comment_Update:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/comment",object ] parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) Event_Participant_Invite:(NSObject*)object: (NSObject*) personID{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/participant/invite/personid/%@",object,personID ] parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) Event_Participants_Invite:(NSObject*)object: (NSObject*) personIDs{
     [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/participant/invite/personids/%@",object,personIDs ] parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) Event_Request_Invitation:(NSObject*)object: (NSObject*) personID{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/requestinvite/personid/%@",object,personID ] parameters:[object JSONRepresentation] method:@"PUT"];
}
-(void) Event_Participants_Get:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/participants",object ] parameters:@"" method:@"GET"];
}
-(void) Event_Participant_Delete:(NSObject*)object : (NSObject*) eventParticipantID{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/participant",object ] parameters:@"" method:@"GET"];
}
-(void) Event_RSVP:(NSObject*)object{
    //no info in website
}
-(void) Events_Search:(NSObject*)object{
    //no info in website
}
-(void) Events_Search_byPersonID:(NSObject*)object : (NSObject*) start :(NSObject *) end{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/events/search/personid/%@/start/%@/end/%@",object ] parameters:@"" method:@"GET"];
}
-(void) Event_AppData_Add:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/appdata",object ] parameters:[object JSONRepresentation] method:@"POST"];
}
-(void) Event_AppData_Delete:(NSObject*)object : (NSObject*) appDataID{
     [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/appdata/%@",object,appDataID ]  parameters:[object JSONRepresentation] method:@"DELETE"];
}
-(void) Event_AppData_Get:(NSObject*)object : (NSObject *) appDataID{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/appdata/%@",object,appDataID ] parameters:@"" method:@"GET"];
}
-(void) Event_AppData_GetAll:(NSObject*)object{
    [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/appdata",object] parameters:@"" method:@"GET"];

}
-(void) Event_AppData_Update:(NSObject*)object{
      [self makeRequest:[NSString stringWithFormat:@"/v09/json/event/%@/appdata",object ] parameters:[object JSONRepresentation] method:@"PUT"];
}


@end
