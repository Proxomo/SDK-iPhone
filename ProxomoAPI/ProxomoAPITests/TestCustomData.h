//
//  TestCustomData.h
//  ProxomoAPI
//
//  Created by Fred Crable on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomData.h"

@interface TestCustomData : CustomData {
    NSString *likes, *dislikes, *foo;
}

@property (nonatomic, strong) NSString *likes, *dislikes, *foo;

@end
