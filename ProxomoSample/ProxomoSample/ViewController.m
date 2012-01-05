    //
//  ViewController.m
//  ProxomoSample
//
//  Created by Fred Crable on 12/19/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "ViewController.h"
#import "DefinitionView.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark App Delegate

-(void)asyncObjectComplete:(BOOL)success proxomoObject:(id)proxomoObject {
    NSLog(@"Async response received for %@", proxomoObject);
    if(!success){
        NSLog(@"Operation Failed for %@", proxomoObject);
        return;
    }
    if([proxomoObject isKindOfClass:[Person class]]){
        DefinitionView *defView = [[DefinitionView alloc] initWithStyle:UITableViewStyleGrouped];
        [defView setUserContext:_userContext];
        [defView setApiContext:_apiContext];
        [defView setPObject:proxomoObject];
        [[self navigationController] pushViewController:defView animated:NO];
    }
}

-(void)authComplete:(BOOL)success withStatus:(NSString*)status forPerson:(id)person{
    if(person == _userContext){
        if([_userContext isAuthorized] == NO){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authorization Failure" message:@"Login Failed" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authorization Success" message:@"User is Logged into Proxomo" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        [_userContext Get:_apiContext];
    }
}

-(void)LoginUser:(id)button {
    _userContext = [[Person alloc] init];
    [_userContext loginToSocialNetwork:FACEBOOK forApplication:_apiContext];
}

-(void)LoginAPI:(id)button {
    _userContext = nil;
    [_apiContext loginApi:self];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(LoginAPI:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Login API" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 170.0, 160.0, 40.0);
    [self.view addSubview:button];
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(LoginUser:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Login User" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 215.0, 160.0, 40.0);
    [self.view addSubview:button];

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
