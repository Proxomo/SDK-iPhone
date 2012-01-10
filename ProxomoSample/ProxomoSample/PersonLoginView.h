//
//  PersonLoginView.h
//  ProxomoSample
//
//  Created by Fred Crable on 12/19/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Proxomo.h>

@interface PersonLoginView : UIViewController <ProxomoAuthDelegate> {
    ProxomoApi *apiContext;
    Person *_userContext;
}

@property (nonatomic,strong) ProxomoApi *apiContext;

@end
