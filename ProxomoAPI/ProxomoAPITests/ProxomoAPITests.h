//
//  ProxomoAPITests.h
//  ProxomoAPITests
//
//  Created by Fred Crable on 11/23/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Proxomo.h"

@interface ProxomoAPITests : SenTestCase <ProxomoAppDelegate> {
    ProxomoApi *_apiContext;
    Person    *_userContext;
    NSRunLoop *runLoop;
    BOOL desiredResult;
}

@property (nonatomic, strong) ProxomoApi *_apiContext;
@property (nonatomic, strong) Person    *_userContext;
@property (nonatomic) BOOL desiredResult;

@end
