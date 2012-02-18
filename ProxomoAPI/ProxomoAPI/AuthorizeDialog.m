//
//  AuthorizeDialog.m
//  ProxomoAPI
//
//  Created by Fred Crable on 12/19/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "AuthorizeDialog.h"
#import <UIKit/UIApplication.h>
#import "ProxomoApi.h"

// view color and screen transform for flipping
static CGFloat kTransitionDuration = 0.3;
static CGFloat kPadding = 0;
static CGFloat kBorderWidth = 10;

///////////////////////////////////////////////////////////////////////////////////////////////////

static BOOL IsDeviceIPad() {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
#endif
    return NO;
}

@implementation AuthorizeDialog

@synthesize auth_result, personID, socialnetwork, socialnetwork_id, access_token;

-(void)initFrame{
    appDelegate = nil;
    loginUrl = nil;
    showingKeyboard = NO;
    
    self.backgroundColor = [UIColor clearColor];
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentMode = UIViewContentModeRedraw;
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(kPadding, kPadding, 480, 480)];
    webView.delegate = self;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:webView];
    
    UIImage* closeImage = [UIImage imageNamed:@"FBDialog.bundle/images/close.png"];
    
    UIColor* color = [UIColor colorWithRed:167.0/255 green:184.0/255 blue:216.0/255 alpha:1];
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:closeImage forState:UIControlStateNormal];
    [closeButton setTitleColor:color forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(cancel)
          forControlEvents:UIControlEventTouchUpInside];
    
    closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];        
    closeButton.showsTouchWhenHighlighted = YES;
    closeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:closeButton];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
               UIActivityIndicatorViewStyleWhiteLarge];
    spinner.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:spinner];
    backgroundView = [[UIView alloc] init];

}

-(id) init{
    if ((self = [super initWithFrame:CGRectZero])) {
        [self initFrame];
    }
    return self;
}

- (id) initWithURL:(NSString *)authURL loginParams:(NSMutableDictionary *)params appDelegate:(id)delegate{
    self = [super init];
    if (self) {
        [self initFrame];
        authParams = params;
        loginUrl = authURL;
        appDelegate = delegate;
    }
    return self;
}

-(void) getAuthURL{
    NSString *openURL = [ProxomoApi serializeURL:loginUrl withParams:authParams];
    NSURL *url = [NSURL URLWithString:openURL];
    NSMutableURLRequest *urlRequest = nil;
    
    urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [webView loadRequest:urlRequest];
}

#pragma mark - Orientation

- (void)updateWebOrientation {
    UIInterfaceOrientation current_orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(current_orientation)) {
        [webView stringByEvaluatingJavaScriptFromString:
         @"document.body.setAttribute('orientation', 90);"];
    } else {
        [webView stringByEvaluatingJavaScriptFromString:
         @"document.body.removeAttribute('orientation');"];
    }
}


- (CGAffineTransform)transformForOrientation {
    UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
    if (o == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (o == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (o == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

- (void)sizeToFitOrientation:(BOOL)transform {
    if (transform) {
        self.transform = CGAffineTransformIdentity;
    }
    
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    CGPoint center = CGPointMake(
                                 frame.origin.x + ceil(frame.size.width/2),
                                 frame.origin.y + ceil(frame.size.height/2));
    
    CGFloat scale_factor = 1.0f;
    if (IsDeviceIPad()) {
        // On the iPad the dialog's dimensions should only be 60% of the screen's
        scale_factor = 0.6f;
    }
    
    CGFloat width = floor(scale_factor * frame.size.width) - kPadding * 2;
    CGFloat height = floor(scale_factor * frame.size.height) - kPadding * 2;
    
    orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.frame = CGRectMake(kPadding, kPadding, height, width);
    } else {
        self.frame = CGRectMake(kPadding, kPadding, width, height);
    }
    self.center = center;
    
    if (transform) {
        self.transform = [self transformForOrientation];
    }
}

- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)current_orientation {
    if (current_orientation == orientation) {
        return NO;
    } else {
        return orientation == UIInterfaceOrientationPortrait
        || orientation == UIInterfaceOrientationPortraitUpsideDown
        || orientation == UIInterfaceOrientationLandscapeLeft
        || orientation == UIInterfaceOrientationLandscapeRight;
    }
}

- (void)deviceOrientationDidChange:(void*)object {
    UIInterfaceOrientation current_orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (!showingKeyboard && [self shouldRotateToOrientation:current_orientation]) {
        [self updateWebOrientation];
        
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [self sizeToFitOrientation:YES];
        [UIView commitAnimations];
    }
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillHideNotification" object:nil];
}

#pragma mark - Status

- (void)postDismissCleanup {
    [self removeObservers];
    [self removeFromSuperview];
    [backgroundView removeFromSuperview];
}

- (void)dismiss:(BOOL)animated {
    loginUrl = nil;
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:kTransitionDuration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(postDismissCleanup)];
        self.alpha = 0;
        [UIView commitAnimations];
    } else {
        [self postDismissCleanup];
    }
}

- (void)dismissWithSuccess:(BOOL)success animated:(BOOL)animated {
    if ([appDelegate respondsToSelector:@selector(authComplete:withStatus:forPerson:)]) {
        [appDelegate authComplete:success withStatus:auth_result forPerson:self];
    }
    [self dismiss:animated];
}

- (void)cancel {
    [self dismissWithSuccess:NONE animated:NO];
}

- (void)dismissWithError:(NSError*)error animated:(BOOL)animated {
    [self dismiss:animated];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [spinner stopAnimating];
    spinner.hidden = YES;
    
    [self updateWebOrientation];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self dismissWithError:error animated:YES];
}

- (NSString *) getStringFromUrl: (NSString*) url needle:(NSString *) needle {
    NSString * str = nil;
    NSRange start = [url rangeOfString:needle];
    if (start.location != NSNotFound) {
        NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
        NSUInteger offset = start.location+start.length;
        str = end.location == NSNotFound
        ? [url substringFromIndex:offset]
        : [url substringWithRange:NSMakeRange(offset, end.location)];
        str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    return str;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    NSURL* url = request.URL;

    NSLog(@"viewing:%@:%@", url.scheme, [url absoluteString]);
    if ( [[url absoluteString] rangeOfString:@"https://service.proxomo.com/LoginComplete.aspx"].location != NSNotFound) {
        /*
          * look for proxomo specific error codes and log specific errors
          */
        auth_result = [self getStringFromUrl:[url absoluteString] needle:@"result="];
        personID = [self getStringFromUrl:[url absoluteString] needle:@"personID="];
        socialnetwork = [self getStringFromUrl:[url absoluteString] needle:@"socialnetwork="];
        socialnetwork_id = [self getStringFromUrl:[url absoluteString] needle:@"socialnetwork_id="];
        access_token = [self getStringFromUrl:[url absoluteString] needle:@"access_token="];
        personID = [self getStringFromUrl:[url absoluteString] needle:@"personID="];
        
        if([auth_result isEqualToString:@"success"]){
            [self dismissWithSuccess:YES animated:YES];
        }else{
            [self dismissWithSuccess:NO animated:NO];
        }
    }else if ([loginUrl isEqual:url]) {
        return YES;
    } else if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
    }
    return YES;
}

#pragma mark - keyboard

- (void)keyboardWillShow:(NSNotification*)notification {
    
    showingKeyboard = YES;
    
    if (IsDeviceIPad()) {
        return;
    }
    
    UIInterfaceOrientation current_orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(current_orientation)) {
        webView.frame = CGRectInset(webView.frame,
                                     -(kPadding + kBorderWidth),
                                     -(kPadding + kBorderWidth));
    }
}

- (void)keyboardWillHide:(NSNotification*)notification {
    showingKeyboard = NO;
    
    if (IsDeviceIPad()) {
        return;
    }
    UIInterfaceOrientation current_orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(current_orientation)) {
        webView.frame = CGRectInset(webView.frame,
                                     kPadding + kBorderWidth,
                                     kPadding + kBorderWidth);
    }
}

#pragma mark - Drawing Code

-(void)expose{
    [self getAuthURL];
    [self sizeToFitOrientation:NO];
    
    CGFloat innerWidth = self.frame.size.width - (kBorderWidth+1)*2;
    [closeButton sizeToFit];
    
    closeButton.frame = CGRectMake(
                                    2,
                                    2,
                                    29,
                                    29);
    
    webView.frame = CGRectMake(
                                kBorderWidth+1,
                                kBorderWidth+1,
                                innerWidth,
                                self.frame.size.height - (1 + kBorderWidth*2));
    
    [spinner sizeToFit];
    [spinner startAnimating];
    spinner.center = webView.center;
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    backgroundView.frame = window.frame;
    [backgroundView addSubview:self];
    [window addSubview:backgroundView];
    
    [window addSubview:self];
    
    //[self dialogWillAppear];
    
    self.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    self.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
    [UIView commitAnimations];
    
    [self addObservers];

}

@end
