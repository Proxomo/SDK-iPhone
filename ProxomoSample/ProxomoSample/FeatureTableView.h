//
//  FeatureTableView.h
//  ProxomoSample
//
//  Created by Fred Crable on 1/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Proxomo.h"

@interface FeatureTableView : UITableViewController {
    NSMutableDictionary *_featureList;
    ProxomoApi *_apiContext;
}

@property (nonatomic, strong) NSMutableDictionary *_featureList;

@end
