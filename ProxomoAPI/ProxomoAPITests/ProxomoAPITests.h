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
    ProxomoApi *apiContext;
    NSRunLoop *runLoop;
}

@property (nonatomic, strong) ProxomoApi *apiContext;
@end
