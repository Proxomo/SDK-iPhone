//
//  PROXOMO_Notifications.m
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 CreativeGurus. All rights reserved.//

#import "PROXOMO_Notifications.h"
#import "SBJson.h"

@interface PROXOMO_Notifications()

@end

@implementation PROXOMO_Notifications

-(void) Notification_Send:(NSObject*)object{
     [self makeRequest:@"/v09/json/notification" parameters:[object JSONRepresentation] method:@"POST"];
}

@end
