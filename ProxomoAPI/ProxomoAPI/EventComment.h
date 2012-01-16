//
//  EventComment.h
//  ProxomoAPI
//
//  Created by Fred Crable on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProxomoObject.h"
#import "Event.h"

@interface EventComment : ProxomoObject {
    NSString *Comment;  ///  User supplied comment text for an Event.
    NSString *EventID;  /// ID of the Event associated with this comment.
    NSString *PersonID; /// ID of the Person commenting on this Event.
    NSString *PersonName;   /// Name of the Person making the comment.
    NSDate *LastUpdate; /// Date and Time of the last update to this comment.
}

@property (nonatomic, strong) NSString *Comment;
@property (nonatomic, strong) NSString *EventID;
@property (nonatomic, strong) NSDate *LastUpdate;
@property (nonatomic, strong) NSString *PersonID;
@property (nonatomic, strong) NSString *PersonName; 

@end
