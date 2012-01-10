//
//  PersonLoginView.m
//  ProxomoSample
//
//  Created by Fred Crable on 12/19/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "PersonLoginView.h"
#import "ProxomoObjectView.h"

@implementation PersonLoginView
@synthesize apiContext;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark App Delegate

-(void)authComplete:(BOOL)success withStatus:(NSString*)status forPerson:(id)person{
    if(person == _userContext){
        if([_userContext isAuthorized] == NO){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authorization Failure" message:@"Could not Login" delegate:nil cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
            [alert show];
        }else{
            ProxomoObjectView *objView = [[ProxomoObjectView alloc] initWithStyle:UITableViewStyleGrouped];
            [objView setUserContext:_userContext];
            [objView setApiContext:apiContext];
            [objView setPObject:_userContext];
            [[self navigationController] pushViewController:objView animated:NO];
        }
    }
}

-(void)back:(id)button {
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)LoginUser:(id)button {
    _userContext = [[Person alloc] init];
    [_userContext setAppDelegate:self];
    [_userContext loginToSocialNetwork:FACEBOOK forApplication:apiContext];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Login"];
    UIImageView *customBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ProxomoBG.png"]];
    [self.view addSubview:customBackground];
    NSLog(@"Added background subview %@", customBackground);
    [self.view sendSubviewToBack:customBackground];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(LoginAPI:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Login API" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 170.0, 160.0, 40.0);
    [self.view addSubview:button];
    */
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(LoginUser:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Login" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 195.0, 160.0, 40.0);
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitle:@"< back" forState:UIControlStateNormal];
    button2.frame = CGRectMake(20.0, 20.0, 50.0, 20.0);
    [self.view addSubview:button2];

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
