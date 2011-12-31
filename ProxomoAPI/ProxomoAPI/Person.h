//
//  Persons.h
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ProxomoObject.h"
#import "AuthorizeDialog.h"

typedef enum {
    FACEBOOK = 0,
    PROXOMO = 1
} enumSocialNetwork;

@interface Person : ProxomoObject <ProxomoAuthDelegate> {
    AuthorizeDialog *loginDialogView;
    
    NSString *_access_token;
    NSString *_socialnetwork;
    NSString *_socialnetwork_id;  
    
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

-(void)loginToSocialNetwork:(enumSocialNetwork)network forApplication:(id)apiContext;
-(BOOL)isAuthorized;

/*
-(void) Person_AppData_Add:(NSObject*)object;
-(void) Person_AppData_Delete:(NSObject*)object : (NSObject*) appDataID;
-(void) Person_AppData_Get:(NSObject*)object : (NSObject *) appDataID;
-(void) Person_AppData_GetAll:(NSObject*)object;
-(void) Person_AppData_Update:(NSObject*)object;
-(void) Person_Locations_Get:(NSObject*)object;
-(void) Person_SocialNetworkInfo_Get:(NSObject*)object;
*/

@property (nonatomic, strong) AuthorizeDialog *loginDialogView;

@end
