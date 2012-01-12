//
//  Notifications.h
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProxomoObject.h"

@interface Notification : ProxomoObject {
    NSString *EMailMessage; ///  No  Body of the email message.
    NSString *EMailSubject; ///  No  Subject of the email message.
    NSString *MobileMessage; ///  No  Message to be sent via SMS to the users mobile device (160 character maximum).
    NSNumber *NotificationType; /// Integer of NotificationType    Yes Determines what type of notification is being sent.NSString *PersonID; ///  ID of the Person the notification is being sent to.NSNumber *SendMethod;  /// Integer of NotificationSendMethod   Yes Determines the method used to send the notification.
}

@property (nonatomic, strong) NSString *EMailMessage;
@property (nonatomic, strong) NSString *EMailSubject;
@property (nonatomic, strong) NSString *MobileMessage;
@property (nonatomic, strong) NSNumber *NotificationType;@property (nonatomic, strong) NSString *PersonID;
@property (nonatomic, strong) NSNumber *SendMethod;  


-(void) Notification_Send:(id)apiContext;

@end
