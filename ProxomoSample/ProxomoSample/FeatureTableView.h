//
//  FeatureTableView.h
//  ProxomoSample
//
//  Created by Fred Crable on 1/8/12.
//  Copyright (c) 2012 Proxomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Proxomo.h"

@interface FeatureTableView : UITableViewController <ProxomoApiDelegate> {
    NSMutableDictionary *_featureList;
    ProxomoApi *_apiContext;
}

@property (nonatomic, strong) NSMutableDictionary *_featureList;

@end
