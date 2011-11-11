//
//  ViewController.h
//  PROXOMO_Demo
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 CreativeGurus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PROXOMO.h"

@interface ViewController : UIViewController<PROXOMODelegate> {
    PROXOMO_AppData * ad;
}
@end
