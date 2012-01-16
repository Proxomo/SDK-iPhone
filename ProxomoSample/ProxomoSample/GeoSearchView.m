//
//  GeoSearchView.m
//  ProxomoSample
//
//  Created by Fred Crable on 1/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GeoSearchView.h"
#import "ProxomoListView.h"
#import "ProxomoObjectView.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation GeoSearchView
@synthesize address, latitude, longitude, ip;
@synthesize apiContext, userContext;

-(void)asyncObjectComplete:(BOOL)success proxomoObject:(id)proxomoObject {
    NSLog(@"Object repsonse %@", proxomoObject);
    if(!success){
        NSLog(@"Operation Failed for %@", proxomoObject);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search Failed" message:@"Try again with a different value"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]; 
        [alert show]; 
        return;
    }
    if ([proxomoObject isKindOfClass:[ProxomoList class]]) {
        ProxomoListView *pListView = [[ProxomoListView alloc] init];
        [pListView setApiContext:apiContext];
        [pListView setUserContext:userContext];
        [pListView setPList:proxomoObject];
        [self.navigationController pushViewController:pListView animated:YES];
    }else{
        ProxomoObjectView *ov = [[ProxomoObjectView alloc] init];
        ov.pObject = proxomoObject;
        ov.apiContext = apiContext;
        ov.userContext = userContext;
        [self.navigationController pushViewController:ov animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    //Terminate editing
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)searchAddress:(id)sender{
    GeoCode *geo = [[GeoCode alloc] init];
    geo.appDelegate = self;
    [geo byAddress:address.text apiContext:apiContext useAsync:YES];
    [address resignFirstResponder];
}

-(IBAction)searchIP:(id)sender{
    GeoCode *geo = [[GeoCode alloc] init];
    geo.appDelegate = self;
    [geo byIPAddress:ip.text apiContext:apiContext useAsync:YES];    
    [ip resignFirstResponder];
}

-(IBAction)searchGeo:(id)sender{
    GeoCode *geo = [[GeoCode alloc] init];
    Location *loc = [[Location alloc] init];
    loc.appDelegate = self;
    [geo byLatitude:[latitude.text doubleValue] byLogitude:[longitude.text doubleValue] locationDelegate:loc apiContext:apiContext];
    [latitude resignFirstResponder];
    [longitude resignFirstResponder];
}


- (NSString *)getIPAddress
{
    NSString *ipAddress = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    ipAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return ipAddress;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Search GeoCodes";
    self.ip.text = [self getIPAddress];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
