//
//  FeatureTableView.m
//  ProxomoSample
//
//  Created by Fred Crable on 1/8/12.
//  Copyright (c) 2012 Proxomo. All rights reserved.
//

#import "FeatureTableView.h"
#import "ProxomoListView.h"
#import "ProxomoObjectView.h"
#import "PersonLoginView.h"
#import "LocationSearchView.h"
#import "GeoSearchView.h"

#define kAppDataRow 0
#define kGeoCodeRow 1
#define kLocationsRow 2
#define kPersonRow 3
#define kEventsRow 4

@implementation FeatureTableView
@synthesize _featureList;

-(void) handleResponse:(NSData*)response requestType:(enumRequestType)requestType responseCode:(NSInteger)code responseStatus:(NSString*) status{
    NSLog(@"Response: %@", status);
}

-(void) handleError:(NSData*)response requestType:(enumRequestType)requestType responseCode:(NSInteger)code responseStatus:(NSString*) status{
    NSLog(@"Error: %@", status);
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
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
    // Custom initialization
    _featureList = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                    @"AppData", [NSNumber numberWithInt:kAppDataRow],
                    @"GeoCode", [NSNumber numberWithInt:kGeoCodeRow],
                    @"Locations", [NSNumber numberWithInt:kLocationsRow],
                    @"Events", [NSNumber numberWithInt:kEventsRow],
                    @"Person", [NSNumber numberWithInt:kPersonRow],
                    nil];
    
    _apiContext = [[ProxomoApi alloc] initWithKey:@"PUT YOUR API KEY HERE" appID:@"PUT YOUR APP KEY HERE" delegate:self];
    self.title = @"Features";
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_featureList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FeatureCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [cell.textLabel setText:[_featureList objectForKey:[NSNumber numberWithInt:indexPath.row]]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonLoginView *pPersonView;
    ProxomoListView *pListView;
    LocationSearchView *locSearchView;
    GeoSearchView  *geoSearchView;
    ProxomoList *pList;
    
    switch (indexPath.row) {
        case kAppDataRow:
            pList = [[ProxomoList alloc] init];
            [pList setListType:APPDATA_TYPE];
            
            pListView = [[ProxomoListView alloc] init];
            [pListView setApiContext:_apiContext];
            [pListView setPList:pList];
            [self.navigationController pushViewController:pListView animated:YES];
            break;
        case kPersonRow:
            pPersonView = [[PersonLoginView alloc] init];
            [pPersonView setApiContext:_apiContext];
            [self.navigationController pushViewController:pPersonView animated:YES];
            break;
        case kLocationsRow:
            locSearchView = [[LocationSearchView alloc] initWithNibName:@"LocationSearchView" bundle:nil];
            [locSearchView setApiContext:_apiContext];
            [self.navigationController pushViewController:locSearchView animated:YES];
            break;
        case kGeoCodeRow:
            geoSearchView = [[GeoSearchView alloc] initWithNibName:@"GeoSearchView" bundle:nil];
            [geoSearchView setApiContext:_apiContext];
            [self.navigationController pushViewController:geoSearchView animated:YES];
            break;
        case kEventsRow:
            pList = [[ProxomoList alloc] init];
            [pList setListType:EVENT_TYPE];
            
            pListView = [[ProxomoListView alloc] init];
            [pListView setApiContext:_apiContext];
            [pListView setPList:pList];
            [self.navigationController pushViewController:pListView animated:YES];
        default:
            break;
    }
}


@end
