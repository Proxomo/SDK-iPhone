//
//  Notifications.h
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProxomoObject.h"

typedef enum {
    NOTIFY_ALL_METHODS	= 0, // Send the notification over both EMail and SMS.
    NOTIFY_EMAIL = 1,        // Send the notification over EMail.
    NOTIFY_SMS = 2,          // Send the notification over SMS.
    UserDefined = 3          // Use the users defined preferences for sending notifications.
} enumNotificationSendMethod;

typedef enum {
    NOTIF_TYPE_EVENT_INVITE = 0,         //	an event invitation.
    NOTIF_TYPE_EVENT_REQUEST = 1,        //	request an event invitation.
    NOTIF_TYPE_SYSTEM_MESSAGE = 2,       // Indicates a system message is being sent.
    NOTIF_TYPE_APPLICATION_MESSAGE = 3,  // an application message is being sent.
    NOTIF_TYPE_FRIEND_INVITE = 4,    // invite someone to a friend relationship.
    NOTIF_TYPE_OTHER = 5,            // Used when no other NotificationType is applicable.
    NOTIF_TYPE_VERIFICATION = 6,     // verifying an email address or mobile number.
} enumNotificationType;

@interface Notification : ProxomoObject {
    NSString *EMailMessage; ///  Body of the email message.
    NSString *EMailSubject; ///  Subject of the email message.
    NSString *MobileMessage; /// Message to be sent via SMS to the users mobile device (160 character maximum).
    NSNumber *NotificationType; /// Determines what type of notification is being sent.
    NSString *PersonID; ///  ID of the Person the notification is being sent to.
    NSNumber *SendMethod;  /// Integer of NotificationSendMethod Determines the method used to send the notification.
}

@property (nonatomic, strong) NSString *EMailMessage;
@property (nonatomic, strong) NSString *EMailSubject;
@property (nonatomic, strong) NSString *MobileMessage;
@property (nonatomic, strong) NSNumber *NotificationType;
@property (nonatomic, strong) NSString *PersonID;
@property (nonatomic, strong) NSNumber *SendMethod;  


-(void) Send:(id)apiContext sendMethod:(enumNotificationSendMethod)method requestType:(enumNotificationType)request;

@end
