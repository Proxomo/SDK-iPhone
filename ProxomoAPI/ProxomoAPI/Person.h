//
//  Persons.h
//  PROXOMO
//
//  Created by Fred Crable on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ProxomoObject.h"
#import "ProxomoList.h"
#import "AuthorizeDialog.h"

typedef enum {
    FACEBOOK = 0,
    PROXOMO = 1
} enumSocialNetwork;

typedef enum {
    FRIEND_IGNORE = 0,
    FRIEND_ACCEPT = 1,
    FRIEND_CANCEL = 2
} enumFriendResponse;

@interface Person : ProxomoObject <ProxomoAuthDelegate> {
    AuthorizeDialog *loginDialogView;
    
    NSString *_socialnetwork;
    NSString *_socialnetwork_id;  
    ProxomoList *_appData;
    
    /**
     Person obtained from social network ID
     */
    NSString *EmailAddress; ///	String	No	EMail address of the Person.
    BOOL EmailAlerts; ///	Boolean	Yes	Determines if the Person has approved to receive alerts and notifications via EMail. (Defaults to False)
    NSString *EmailVerificationCode; ///	String	No	Verification code used to verify the EMail address of the Person.  This code should be sent to the user and verified.
    NSNumber *EmailVerificationStatus; ///	Integer of VerificationStatus	Yes	Indicates the EMail verification status.
    BOOL EmailVerified; ///	Boolean	Yes	Determines if the EMail address has been properly verified. (Defaults to False)
    NSString *FacebookID; ///	String	No	Facebook unique identifier.
    NSString *FirstName; ///	String	Yes	First Name of the Person.
    NSString *FullName; ///	String	Yes	Full Name of the Person.
    NSString *ImageURL; ///	String	No	Image URL of the Person.
    NSDate *LastLogin; ///	DateTime	No	Last Date and Time the Person logged into Proxomo.
    NSString *LastName; ///	String	Yes	Last Name of the Person.
    BOOL MobileAlerts; ///	Boolean	Yes	Determines if the Person has approved to receive alerts and notifications via SMS. (Defaults to False)
    NSString *MobileNumber; ///	String	No	Mobile phone number of the Person.
    NSString *MobileVerificationCode; ///	String	No	Verification code used to verify the mobile number of the Person.  This code should be sent to the user and verified.
    NSNumber *MobileVerificationStatus; ///	Integer of VerificationStatus	Yes	Indicates the Mobile verification status.
    BOOL MobileVerified; ///	Boolean	Yes	Determines if the Mobile Number as been properly verified. (Defaults to False)
    NSString *TwitterID; ///	String	No	Please note: While TwitterID is defined Twitter integration has not yet been added to Proxomo.
    NSString *UserName; ///	String	No	This field is not used by Proxomo.  Developers can use this field to associate a Person to another account if needed.
    double UTCOffset; ///	Double	No	Coordinate Universal Time Offset of the Person.
}

/**
 Obtains the correct person ID using the login application for a social network
 */
-(void)loginToSocialNetwork:(enumSocialNetwork)network forApplication:(id)apiContext;
-(BOOL)isAuthorized;
-(NSArray*)appData;
-(void)friendInvite:(NSString*)personID;
-(void)friendRespond:(NSString*)personID withResponse:(enumFriendResponse)response;
-(void)friendInvite:(NSString*)socialID inSocialNetwork:(enumSocialNetwork)network;



@property (nonatomic, strong) NSString *EmailAddress;
@property (nonatomic) BOOL EmailAlerts; 
@property (nonatomic, strong) NSString *EmailVerificationCode;
@property (nonatomic, strong) NSNumber *EmailVerificationStatus; 
@property (nonatomic) BOOL EmailVerified; 
@property (nonatomic, strong) NSString *FacebookID; ///	String	No	Facebook unique identifier.
@property (nonatomic, strong) NSString *FirstName; ///	String	Yes	First Name of the Person.
@property (nonatomic, strong) NSString *FullName; ///	String	Yes	Full Name of the Person.
@property (nonatomic, strong) NSString *ImageURL; ///	String	No	Image URL of the Person.
@property (nonatomic, strong) NSDate *LastLogin; ///	DateTime	No	Last Date and Time the Person logged into Proxomo.
@property (nonatomic, strong) NSString *LastName; ///	String	Yes	Last Name of the Person.
@property (nonatomic) BOOL MobileAlerts; 
@property (nonatomic, strong) NSString *MobileNumber; ///	String	No	Mobile phone number of the Person.
@property (nonatomic, strong) NSString *MobileVerificationCode;
@property (nonatomic, strong) NSNumber *MobileVerificationStatus;
@property (nonatomic) BOOL MobileVerified;
@property (nonatomic, strong) NSString *TwitterID;
@property (nonatomic, strong) NSString *UserName;
@property (nonatomic) double UTCOffset;

@end
