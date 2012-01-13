//
//  LocationSearchView.h
//  ProxomoSample
//
//  Created by Fred Crable on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Proxomo.h"

@interface LocationSearchView : UIViewController <ProxomoAppDelegate, UITextFieldDelegate> {
    UITextField *address;
    UITextField *latitude;
    UITextField *longitude;
    UITextField *ip;
    ProxomoApi *apiContext;
    Person *_userContext;
    ProxomoList *pList;

}

-(IBAction)searchAddress:(id)sender;
-(IBAction)searchIP:(id)sender;
-(IBAction)searchGeo:(id)sender;

@property (nonatomic, strong)  IBOutlet UITextField  *address, *latitude, *longitude, *ip;
@property (nonatomic,strong) ProxomoApi *apiContext;

@end
