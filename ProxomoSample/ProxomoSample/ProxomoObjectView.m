//
//  DefinitionView.m
//  ProxomoSample
//
//  Created by Fred Crable on 1/4/12.
//  Copyright (c) 2012 Proxomo. All rights reserved.
//

#import "ProxomoObjectView.h"
#import "ProxomoListView.h"

@implementation ProxomoObjectView
@synthesize userContext;
@synthesize apiContext;
@synthesize pObject;
@synthesize objectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

#pragma mark - Buttons

-(void)getAppData:(id)button {
    ProxomoList *pList = [[ProxomoList alloc] init];
    [pList setListType:APPDATA_TYPE];
    ProxomoListView *pListView = [[ProxomoListView alloc] init];
    [pListView setPList:pList];
    [pListView setApiContext:apiContext];
    [pListView setObjectContext:pObject];
    [pListView setUserContext:userContext];
    [self.navigationController pushViewController:pListView animated:YES];
}

-(void)getFriends:(id)button {
    ProxomoList *pList = [[ProxomoList alloc] init];
    ProxomoListView *pListView = [[ProxomoListView alloc] init];
    
    [pList setListType:SOCIALNETFRIEND_TYPE];
    [pListView setPList:pList];
    [pListView setApiContext:apiContext];
    
    if([pObject isKindOfClass:[SocialNetworkPFriend class]]){
        // get the friend's friends
        Person *friend = [[Person alloc] init];
        SocialNetworkPFriend *pFriend = (SocialNetworkPFriend*)pObject;
        friend.ID = pFriend.PersonID;
        [apiContext setAsync:NO];
        [friend Get:apiContext];
        [apiContext setAsync:YES];
        [pListView setObjectContext:friend];
        [pListView setUserContext:friend];
    }else{
        [pListView setObjectContext:pObject];
        [pListView setUserContext:userContext];
    }
    [self.navigationController pushViewController:pListView animated:YES];
}

-(void)getPFriends:(id)button {
    ProxomoList *pList = [[ProxomoList alloc] init];
    [pList setListType:APPFRIEND_TYPE];
    
    ProxomoListView *pListView = [[ProxomoListView alloc] init];
    [pListView setPList:pList];
    [pListView setApiContext:apiContext];
    [pListView setObjectContext:pObject];
    [pListView setUserContext:userContext];
    [self.navigationController pushViewController:pListView animated:YES];
}
-(void)getEvents:(id)button {
    ProxomoList *pList = [[ProxomoList alloc] init];
    [pList setListType:EVENT_TYPE];
    ProxomoListView *pListView = [[ProxomoListView alloc] init];
    [pListView setPList:pList];
    [pListView setApiContext:apiContext];
    [pListView setObjectContext:pObject];
    [pListView setUserContext:userContext];
    [self.navigationController pushViewController:pListView animated:YES];
}

-(void)getComments:(id)button {
    ProxomoList *pList = [[ProxomoList alloc] init];
    [pList setListType:EVENTCOMMENT_TYPE];
    ProxomoListView *pListView = [[ProxomoListView alloc] init];
    [pListView setPList:pList];
    [pListView setApiContext:apiContext];
    [pListView setObjectContext:pObject];
    [pListView setUserContext:userContext];
    [self.navigationController pushViewController:pListView animated:YES];
}

-(void)friendInvite:(id)button {
    Person *p = (Person*)userContext;
    [p friendInvite:pObject.ID inSocialNetwork:FACEBOOK];
}

-(void)notifyFriend:(id)button {
    SocialNetworkPFriend *pFriend = (SocialNetworkPFriend*)pObject;
    Person *friend = [[Person alloc] init];
    Notification *notif = [[Notification alloc] init];
    
    friend.ID = pFriend.PersonID;
    [apiContext setAsync:NO];
    [friend Get:apiContext];
    friend.EmailVerificationStatus = [NSNumber numberWithInt:1];
    friend.EmailVerified = true;
    friend.MobileVerificationStatus = [NSNumber numberWithInt:1];
    friend.MobileVerified = true;
    [friend Update:apiContext];
    [apiContext setAsync:YES];
    

    notif.MobileMessage = @"I want to be your friend!";
    notif.EMailSubject = @"Friend Request";
    notif.EMailMessage = @"I want to be your friend";
    notif.PersonID = pFriend.PersonID;    
    [notif Send:apiContext sendMethod:NOTIFY_ALL_METHODS requestType:NOTIF_TYPE_FRIEND_INVITE];
}

-(void)pfriendInvite:(id)button {
    Person *p = (Person*)userContext;
    SocialNetworkPFriend *pFriend = (SocialNetworkPFriend*)pObject;
    [p friendInvite:pFriend.PersonID];
}

#pragma mark - app delegate

-(void)asyncObjectComplete:(BOOL)success proxomoObject:(id)proxomoObject {
    NSLog(@"Object repsonse %@", proxomoObject);
    if(!success){
        NSLog(@"Operation Failed for %@", proxomoObject);
        return;
    }
    if([pObject description])
        [self setTitle:[pObject description]];
    else
        [self setTitle:[pObject ID]];
    [self.navigationController setTitle:[pObject description]];
    [self.tableView reloadData];
}

-(void) loadPObject {
    [pObject setAppDelegate:self];
    if(objectContext)
        [pObject Get:objectContext];
    else
        [pObject Get:apiContext];
}

-(void)reload:(id)button {
    [self loadPObject];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    Class clazz = [pObject class];
    _ivars = class_copyIvarList(clazz, &_count);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *appDataButton = [[UIBarButtonItem alloc] initWithTitle: @"Data" style: UIBarButtonItemStylePlain target:self action: @selector(getAppData:)];
    UIBarButtonItem *friendsButton = [[UIBarButtonItem alloc] initWithTitle: @"Friends" style: UIBarButtonItemStylePlain target:self action: @selector(getFriends:)];
    UIBarButtonItem *pfriendsButton = [[UIBarButtonItem alloc] initWithTitle: @"PFriends" style: UIBarButtonItemStylePlain target:self action: @selector(getPFriends:)];
    UIBarButtonItem *eventsButton = [[UIBarButtonItem alloc] initWithTitle: @"Events" style: UIBarButtonItemStylePlain target:self action: @selector(getEvents:)];
    UIBarButtonItem *commentButton = [[UIBarButtonItem alloc] initWithTitle: @"Events" style: UIBarButtonItemStylePlain target:self action: @selector(getComments:)];
    UIBarButtonItem *inviteButton = [[UIBarButtonItem alloc] initWithTitle: @"Invite" style: UIBarButtonItemStylePlain target:self action: @selector(friendInvite:)];
    UIBarButtonItem *invitePButton = [[UIBarButtonItem alloc] initWithTitle: @"Invite" style: UIBarButtonItemStylePlain target:self action: @selector(pfriendInvite:)];
    UIBarButtonItem *notifyButton = [[UIBarButtonItem alloc] initWithTitle: @"Notify" style: UIBarButtonItemStylePlain target:self action: @selector(notifyFriend:)];
    
    [super viewWillAppear:animated];
    if ([pObject isKindOfClass:[GeoCode class]] == false &&
        [pObject isKindOfClass:[Location class]] == false &&
        [pObject isKindOfClass:[SocialNetworkFriend class]] == false &&
        [pObject isKindOfClass:[EventComment class]] == false &&
        [pObject isKindOfClass:[SocialNetworkPFriend class]] == false )
    {
        self.title = @"Loading...";
        [self loadPObject];
    }else{
        self.title = [pObject description];
    }
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlackOpaque];  //for example
    //set the toolbar buttons
    if ([pObject isKindOfClass:[Person class]]) {
        [self setToolbarItems:[NSArray arrayWithObjects:appDataButton, friendsButton, pfriendsButton, eventsButton, nil]];
    }else if([pObject isKindOfClass:[Location class]]){
        [self setToolbarItems:[NSArray arrayWithObjects:appDataButton, nil]];
    }else if([pObject isKindOfClass:[Event class]]){
        [self setToolbarItems:[NSArray arrayWithObjects:appDataButton, commentButton, nil]];
    }else if([pObject isKindOfClass:[SocialNetworkFriend class]]){
        [self setToolbarItems:[NSArray arrayWithObjects:inviteButton, nil]];
    }else if([pObject isKindOfClass:[SocialNetworkPFriend class]]){
        [self setToolbarItems:[NSArray arrayWithObjects:invitePButton, notifyButton, friendsButton, nil]];
    }
     
    [self.navigationController setToolbarHidden:NO];
    self.hidesBottomBarWhenPushed = YES;
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
    return _count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...

    const char *ivarName = ivar_getName(_ivars[indexPath.row]);
    NSString *name = [NSString  stringWithCString:ivarName encoding:NSUTF8StringEncoding];
    const char *varType = ivar_getTypeEncoding(_ivars[indexPath.row]);
    char ivarType = varType[0];
    
    
    id ivarValue;
    ptrdiff_t offset;
    int ival = 0;
    long lval = 0;
    double dval;
    //NSString *jsonDate;
    NSString *label = @"private";
    char cval;

    
    [cell.detailTextLabel setText:name];
    offset = ivar_getOffset(_ivars[indexPath.row]);
    if (ivarName[0] != '_') {
        switch (ivarType) {
            case '@':
                ivarValue = object_getIvar(pObject, _ivars[indexPath.row]);
                if(!ivarValue || [ivarValue isKindOfClass:[NSNull class]]){
                    //NSLog(@"Empty json value:%@",key);
                    label = @"";
                } else if ([ivarValue isKindOfClass:[NSDate class]]) {
                    /*
                    dval = [(NSDate*)ivarValue timeIntervalSince1970] * 1000;
                    jsonDate = [NSString stringWithFormat:@"/Date(%ld)/",dval];
                    [dict setValue:jsonDate forKey:key]; 
                     */
                    // TODO
                }else if ([ivarValue isKindOfClass:[NSString class]]){
                    label = ivarValue;
                }else if ([ivarValue isKindOfClass:[NSNumber class]]){
                    label = [ivarValue stringValue];
                }
                break;
            case 'd':
                dval = *(double *)((__bridge void*)pObject + offset);
                label = [[NSNumber numberWithDouble:dval] stringValue];
                break;
            case 'i':
                ival = *(int *)((__bridge void*)pObject + offset);
                label = [[NSNumber numberWithInt:ival] stringValue];
                break;
            case 'l':
                lval = *(long *)((__bridge void*)pObject + offset);
                label = [[NSNumber numberWithLong:lval] stringValue];
                break;
            case 'c':
                cval = *(char *)((__bridge void*)pObject + offset);
                if (cval==0) {
                    label = @"No";
                }else label = @"Yes";
                break;
            default:
                label = @"invalid type";
                break;
        }
    }
    [cell.textLabel setText:label];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
