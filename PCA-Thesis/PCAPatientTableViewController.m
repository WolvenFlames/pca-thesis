//
//  PCAPatientTableViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 8/27/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCAPatientTableViewController.h"

#import "PCADefinitions.h"
#import "Catalyze.h"
#import "PCAPatientDetailViewController.h"

@interface PCAPatientTableViewController ()

@end

@implementation PCAPatientTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 When the view loads, execute the query
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = YES;
    
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Set up app delegate object for use of shared functions
    self.appDel = [[UIApplication sharedApplication] delegate];
    
    [self executeQuery];
}

/**
 Executes the Catalyze query on esasEntry classes
 If the user is in the doctor's ACL, this will return values
 It then filters to the most recent for each unique ID and saves them to an instance var
 TODO should also filter to patients assigned to this particular doctor id?
 @return void
 */
-(void) executeQuery
{
    CatalyzeQuery* query = [CatalyzeQuery queryWithClassName:@"esasEntry"];
    [query setPageNumber:1];
    [query setPageSize:100];
    
    NSMutableDictionary* checkedIDs = [[NSMutableDictionary alloc] init]; //hashtable holding IDs we've already checked
    
    //TODO--should also be filtering to just the doctor's patients? right now, he sees all esasEntries
    [query retrieveAllEntriesInBackgroundWithSuccess:^(NSArray *result)
    {
        [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
            CatalyzeEntry* entry = obj;
            if ([checkedIDs objectForKey:entry.authorId] == nil)
            {
                NSMutableArray* sameIDs = [[NSMutableArray alloc] init];
                [sameIDs addObject:entry];
                for (NSUInteger i = idx + 1; i < [result count]; i++)
                {
                    CatalyzeEntry* newEntry = [result objectAtIndex:i];
                    if (newEntry.authorId == entry.authorId)
                    {
                        [sameIDs addObject:newEntry];
                    }
                }
                
                //once we have all the IDs, get the most recent
                NSArray* immutableArr = sameIDs;
                CatalyzeEntry* mostRecent = [self.appDel.defObj findMostRecent:immutableArr];
                [checkedIDs setObject:mostRecent forKey:mostRecent.authorId];
            }
        }];
        //at this point, we should have the most recent entry for each user
        self.recentEntries = [checkedIDs allValues];
        [self.tableView reloadData];
    }
    failure:^(NSDictionary *result, int status, NSError *error)
     {
         //TODO handle this failure case
     }];
}

/**
 Computes the number of urgent entries in the given entry
 @param entry Full CatalyzeEntry (not just the urgents dictionary!)
 @return urgentSum int representing how many symptoms are urgent
 */
-(int) urgentSum: (CatalyzeEntry*)entry
{
    NSArray* urgents = [(NSDictionary*)[entry.content valueForKey:@"urgent"] allValues];
    
    int count = 0;
    for (NSUInteger i = 0; i < [urgents count]; i++)
    {
        if ([[urgents objectAtIndex:i] intValue] > 0)
        {
            count++;
        }
    }
    
    return count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; //one section for now
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recentEntries count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"patientCell" forIndexPath:indexPath];
    CatalyzeEntry* entry = [self.recentEntries objectAtIndex:indexPath.row];
    
    UILabel* cellLabel = (UILabel*)[cell viewWithTag:111];
    cellLabel.text = entry.authorId; //TODO -- how to get usernames?
    
    UILabel* urgentLabel = (UILabel*)[cell viewWithTag:222];
    NSString* labelText = [NSString stringWithFormat:@"#Urgent: %d", [self urgentSum:entry]];
    urgentLabel.text = labelText;
    if ([self urgentSum:entry] > 0)
    {
        urgentLabel.textColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:1];
    }
    
    return cell;
}

/**
 Event triggered when doctor clicks a patient's name
 @param tableView UITableView*
 @param indexPath NSIndexPath representing the specific cell clicked
 @return void
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedEntry = [self.recentEntries objectAtIndex:indexPath.row]; //preserve the entry for the segue
    [self performSegueWithIdentifier:@"patientDetailSegue" sender:self];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PCAPatientDetailViewController* nextVC = [segue destinationViewController];
    nextVC.selectedEntry = self.selectedEntry;
}


@end
