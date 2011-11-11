//
//  ViewController.m
//  PROXOMO_Demo
//
//  Created by Charisse Dirain on 10/26/11.
//  Copyright (c) 2011 CreativeGurus. All rights reserved.
//

#import "ViewController.h"

#import "PROXOMO.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    ad = [[PROXOMO_AppData alloc] init];
    ad.apikey =@"xEEF1e56ghNixRIaixe2USHoQTnZVm7tqzzfMGemoX8=";
    ad.applicationid=@"ihjNViYPiCGMdnjR";
    ad.delegate = self;
    NSDictionary * appDataTest = [NSDictionary dictionaryWithObjectsAndKeys:@"Name",@"Key",@"Cha",@"Value",@"First Name",@"ObjectType", nil];
    [ad AppData_Add:appDataTest];
}
-(void)ProxomoGeoCodeByIPAddressEventHandler:(NSDictionary*)result {
    
}
-(void) AppData_AddEventHandler:(NSString*)response {
    [ad AppData_Get:response];
}
-(void) AppData_DeleteEventHandler:(NSString*)response {
    
}
-(void) AppData_GetEventHandler:(NSString*)response {
    
}
-(void) AppData_GetAllEventHandler:(NSString*)response {
    
}
-(void) AppData_UpdateEventHandler:(NSString*)response {
    
}
-(void) AppData_SearchEventHandler:(NSString*)response {
    
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
