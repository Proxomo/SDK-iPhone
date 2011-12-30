//
//  ViewController.m
//  ProxomoSample
//
//  Created by Fred Crable on 12/19/11.
//  Copyright (c) 2011 Proxomo. All rights reserved.
//

#import "ViewController.h"
#import "Proxomo.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark API Delegate

-(void)asyncObjectComplete:(BOOL)success proxomoObject:(id)proxomoObject{
    NSLog(@"Async response received for %@", proxomoObject);
}

-(void)Proxomo:(id)button {
    userContext = [[Person alloc] initWithContext:apiContext];
    [userContext loginToSocialNetwork:FACEBOOK];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    apiContext = [[ProxomoApi alloc] initWithKey:@"xEEF1e56ghNixRIaixe2USHoQTnZVm7tqzzfMGemoX8=" appID:@"ihjNViYPiCGMdnjR" andDelegate:self];
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
    [button addTarget:self 
               action:@selector(Proxomo:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Proxomo" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
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
