//
//  AuthorizeDialog.h
//  ProxomoAPI
//
//  Created by Fred Crable on 12/19/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
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
    NSString *responseUrl;
    NSMutableDictionary *authParams;
    __weak id appDelegate;
    
    UIWebView *webView;
    UIView *backgroundView;
    UIActivityIndicatorView *spinner;
    UIButton *closeButton;
    UIInterfaceOrientation orientation;
    BOOL showingKeyboard;
    
    NSString *auth_result;
    NSString *personID;
    NSString *socialnetwork;
    NSString *socialnetwork_id;
    NSString *access_token;
}

@property (nonatomic, strong) NSString *auth_result;
@property (nonatomic, strong) NSString *personID;
@property (nonatomic, strong) NSString *socialnetwork;
@property (nonatomic, strong) NSString *socialnetwork_id;
@property (nonatomic, strong) NSString *access_token;



-(id)initWithURL:(NSString*) loginDialogURL loginParams:(NSMutableDictionary*)params
     appDelegate:(id)delegate;

-(void)expose;

@end
