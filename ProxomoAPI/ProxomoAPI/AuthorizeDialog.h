//
//  AuthorizeDialog.h
//  ProxomoAPI
//
//  Created by Fred Crable on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ProxomoAuthDelegate
/**
 Delegate function indicates completion of asynchronous operation
 @returns success or failure to complete operation
 */
-(void)authComplete:(BOOL)success withStatus:(NSString*)status forPerson:(id)person;

@end


@interface AuthorizeDialog : UIView <UIWebViewDelegate> {
    NSString *loginUrl;
    NSMutableDictionary *authParams;
    __weak id appDelegate;
    
    UIWebView* webView;
    UIView* backgroundView;
    UIActivityIndicatorView* spinner;
    UIButton* closeButton;
    UIInterfaceOrientation orientation;
    BOOL showingKeyboard;
    
}

-(id)initWithURL:(NSString*) loginDialogURL loginParams:(NSMutableDictionary*)params
     appDelegate:(id)delegate;

-(void)expose;

@end
