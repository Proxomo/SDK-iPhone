//
//  AuthorizeDialog.m
//  ProxomoAPI
//
//  Created by Fred Crable on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthorizeDialog.h"
#import <UIKit/UIApplication.h>
#import "ProxomoApi.h"

// view color and screen transform for flipping
static CGFloat kBorderGray[4] = {0.3, 0.3, 0.3, 0.8};
static CGFloat kBorderBlack[4] = {0.3, 0.3, 0.3, 1};
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
    }
    return self;
}

-(void) getAuthURL{
    NSString *openURL = [ProxomoApi serializeURL:loginUrl withParams:authParams];
    NSURL *url = [NSURL URLWithString:openURL];
    NSMutableURLRequest *urlRequest = nil;
    
    urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    NSLog(@"WebView: %@", url);
    [webView loadRequest:urlRequest];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
