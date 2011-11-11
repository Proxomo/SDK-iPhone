//
//  PROXOMO_Events.h
//  PROXOMO
//
//  Created by Ray Venenoso.
//  Copyright 2011 MSU-IIT. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PROXOMO_Events : NSObject {
    
}
-(void) Event_Add;
-(void) Event_Get;
-(void) Event_Update;
-(void) Event_Comment_Add;
-(void) Event_Comment_Delete;
-(void) Event_Comments_Get;
-(void) Event_Comment_Update;
-(void) Event_Participant_Invite;
-(void) Event_Participants_Invite;
-(void) Event_Request_Invitation;
-(void) Event_Participants_Get;
-(void) Event_Participant_Delete;
-(void) Event_RSVP;
-(void) Events_Search;
-(void) Events_Search_byPersonID;
-(void) Event_AppData_Add;
-(void) Event_AppData_Delete;
-(void) Event_AppData_Get;
-(void) Event_AppData_GetAll;
-(void) Event_AppData_Update;

@end
