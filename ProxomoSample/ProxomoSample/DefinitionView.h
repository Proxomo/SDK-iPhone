//
//  DefinitionView.h
//  ProxomoSample
//
//  Created by Fred Crable on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Proxomo.h"
#import <objc/runtime.h>

@interface DefinitionView : UITableViewController {
    ProxomoApi *apiContext;
    Person *userContext;
    ProxomoObject *pObject;
    u_int _count;
    Ivar* _ivars;
}

@property (nonatomic,strong) ProxomoApi *apiContext;
@property (nonatomic,strong) Person *userContext;
@property (nonatomic,strong) ProxomoObject *pObject;

@end
