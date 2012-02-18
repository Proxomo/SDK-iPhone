//
//  DefinitionView.h
//  ProxomoSample
//
//  Created by Fred Crable on 1/4/12.
//  Copyright (c) 2012 Proxomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Proxomo.h"
#import <objc/runtime.h>

@interface ProxomoObjectView : UITableViewController <ProxomoAppDelegate> {
    ProxomoApi *apiContext;
    Person *userContext;
    ProxomoObject *pObject;
    ProxomoObject *objectContext;
    u_int _count;
    Ivar* _ivars;
}

@property (nonatomic,strong) ProxomoApi *apiContext;
@property (nonatomic,strong) Person *userContext;
@property (nonatomic,strong) ProxomoObject *pObject;
@property (nonatomic,strong) ProxomoObject *objectContext;

@end
