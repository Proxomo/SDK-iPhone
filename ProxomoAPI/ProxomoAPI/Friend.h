//
//  Friend.h
//  PROXOMO
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProxomoObject.h"

@interface Friend : ProxomoObject {

     NSString *FacebookID;    ///	String	No	FacebookID for this Person
     NSString *FirstName;     ///	String	Yes	First Name for this Person
     NSNumber *FriendStatus;  /// Integer of FriendStatus	Yes	Status of this Friendship
     NSString *FullName;      /// String	Yes	Full Name for this Person
     NSString *ImageURL;      ///	String	Yes	Image URL for this Person
     NSString *LastName;      ///	String	Yes	Last Name for this Person
     NSString *PersonID;      ///	String	Yes	ID for this Person
     NSString *TwitterID;     ///	String	No	Please note: While TwitterID is defined Twitter integration has not yet been added to Proxomo.
}

@property (nonatomic, strong) NSString *FacebookID;    ///	FacebookID for this Person
@property (nonatomic, strong) NSString *FirstName;     ///	First Name for this Person
@property (nonatomic, strong) NSNumber *FriendStatus;  /// Status of this Friendship
@property (nonatomic, strong) NSString *FullName;      /// Full Name for this Person
@property (nonatomic, strong) NSString *ImageURL;      ///	Image URL for this Person
@property (nonatomic, strong) NSString *LastName;      ///	Last Name for this Person
@property (nonatomic, strong) NSString *PersonID;      ///	ID for this Person
@property (nonatomic, strong) NSString *TwitterID;     

@end
