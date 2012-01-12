//
//  Notifications.m
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.//

#import "Notification.h"

@implementation Notification
@synthesize EMailMessage;
@synthesize EMailSubject;
@synthesize MobileMessage;
@synthesize NotificationType;
@synthesize PersonID;
@synthesize SendMethod;                    

-(enumObjectType) objectType{
    return NOTIFICATION_TYPE;
}

-(NSString *) objectPath{
    return @"notification";
}

-(void) Notification_Send:(id)apiContext{
    
}

@end
