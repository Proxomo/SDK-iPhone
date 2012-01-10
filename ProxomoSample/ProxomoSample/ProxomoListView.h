//
//  ProxomoListView.h
//  ProxomoSample
//
//  Created by Fred Crable on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Proxomo.h"

@interface ProxomoListView : UITableViewController {
    ProxomoApi *apiContext;
    ProxomoObject *objectContext;
    ProxomoList *pList;
}

@property (nonatomic,strong) ProxomoApi *apiContext;
@property (nonatomic,strong) ProxomoObject *objectContext;
@property (nonatomic,strong) ProxomoList *pList;

@end
