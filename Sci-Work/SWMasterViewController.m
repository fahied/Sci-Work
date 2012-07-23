//
//  SWMasterViewController.m
//  Sci-Work
//
//  Created by userXD on 17.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SWMasterViewController.h"



@interface SWMasterViewController () {
    NSMutableArray *_objects;
}
-(void) fetchGroupNamesFromServer;
-(void)extractGroupInfo: (NSMutableArray*)json;

@end





@implementation SWMasterViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)dealloc
{
    [_objects release];
    [super dealloc];
}


-(BOOL) hasInternet{
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.google.com"];
    
    NetworkStatus internetStats = [reach currentReachabilityStatus];
    
    if (internetStats == NotReachable)
    {
        UIAlertView *alertOne = [[UIAlertView alloc] initWithTitle:@"Internet" message:@"is DOWN!!!" delegate:self cancelButtonTitle:@"Damnit!!" otherButtonTitles:@"Cancel", nil];
        
        [alertOne show];
        
        [alertOne release];
    }
    else {
        UIAlertView *alertTwo = [[UIAlertView alloc] initWithTitle:@"Internet" message:@"is WORKING!!!" delegate:self cancelButtonTitle:@"Cool!!" otherButtonTitles:@"Cancel", nil];
        
        [alertTwo show];
        
        [alertTwo release];
    }
    
    return YES;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self hasInternet];
    [self fetchGroupNamesFromServer];
	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//
//    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)] autorelease];
//    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listofGroupName.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    NSDate *object = [listofGroupName objectAtIndex:indexPath.row];

    cell.textLabel.text = [object description];
    
    return cell;
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([[segue identifier] isEqualToString:@"showTasks"])
    {
        SWTaskViewController *viewController = [segue destinationViewController];
        viewController.groupInfo = [self.tableView indexPathForSelectedRow];

        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        // extract group info and pass to next view
        
        NSString *object = [listofGroupId objectAtIndex:indexPath.row];
        
        [[segue destinationViewController] setGroupInfo:object];
    }
}
    
    
 // utility methods
    
-(void) fetchGroupNamesFromServer
{
    NSString *urlString = [NSString stringWithFormat:@"http://imediamac11.uio.no:9000/group"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    
    NSMutableArray *json = (NSMutableArray*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSLog(@"%@", [json objectAtIndex:0]);
    [self extractGroupInfo:json];

}


// searching inside array of dictionaries
-(void)extractGroupInfo: (NSMutableArray*)json
{
    NSMutableArray *groupNames = [NSMutableArray array];
    NSMutableArray *groupIds = [NSMutableArray array];
    
    
    for (NSDictionary *dict in json)
            {
                NSString *name = [[NSString alloc] init] ;
                NSString *idd = [[NSString alloc] init] ;
                
                
                name = [dict objectForKey:@"name"];
                [groupNames addObject:name];
                
                idd = [dict objectForKey:@"id"];
                [groupIds addObject:idd];
            }
    
    listofGroupName = [[NSMutableArray alloc]initWithArray:groupNames]; 
    
    listofGroupId =  [[NSMutableArray alloc]initWithArray:groupIds]; 
    
    NSLog(@"Group Names Array = %@", listofGroupName);
    NSLog(@"Group Names Array = %@", listofGroupId);
}


@end
