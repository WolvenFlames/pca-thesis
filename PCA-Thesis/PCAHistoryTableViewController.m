//
//  PCAHistoryTableViewController.m
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import "PCAHistoryTableViewController.h"

@interface PCAHistoryTableViewController ()

@end

@implementation PCAHistoryTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    // initialize list of symptoms
    self.tableData = [NSArray arrayWithObjects:@"Pain", @"Activity", @"Nausea", @"Depression", @"Anxiety", @"Drowsiness", @"Appetite", @"Weakness", @"Breathing", nil];
    
    if (self.currentEntry != NULL)
    {
        // pull data from survey currently being viewed
        self.data = [NSArray arrayWithObjects:[self.currentEntry.content valueForKey:@"pain"], [self.currentEntry.content valueForKey:@"activity"], [self.currentEntry.content valueForKey:@"nausea"], [self.currentEntry.content valueForKey:@"depression"], [self.currentEntry.content valueForKey:@"anxiety"], [self.currentEntry.content valueForKey:@"drowsiness"], [self.currentEntry.content valueForKey:@"appetite"], [self.currentEntry.content valueForKey:@"weakness"], [self.currentEntry.content valueForKey:@"shortness_of_breath"], nil];
    }
    
    // IMPORTANT -- update tableview to show current survey
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    NSInteger value = [[self.data objectAtIndex:indexPath.row] integerValue];
    switch (value)
    {
        case 1:
            cell.detailTextLabel.text = @"Excellent";
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.backgroundColor = TABLE_GREEN;
            break;
        case 2:
            cell.detailTextLabel.text = @"Good";
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.backgroundColor = TABLE_BLUE;
            break;
        case 3:
            cell.detailTextLabel.text = @"Okay";
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.backgroundColor = TABLE_YELLOW;
            break;
        case 4:
            cell.detailTextLabel.text = @"Poor";
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.backgroundColor = TABLE_ORANGE;
            break;
        case 5:
            cell.detailTextLabel.text = @"Severe";
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.backgroundColor = TABLE_RED;
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 39;
}

/**
 Finds the most recent entry in the query results
 @param result NSArray returned by Catalyze query function
 @return CatalyzeEntry* most recent entry
 */
-(CatalyzeEntry*) findcurrentEntry:(NSArray*) result
{
    CatalyzeEntry* currentEntry = result[0];
    
    for (CatalyzeEntry* entry in result)
    {
        NSComparisonResult comp = [currentEntry.createdAt compare:entry.createdAt];
        if (comp == NSOrderedAscending)
        {
            currentEntry = entry;
        }
        //else, leave it--doesn’t matter
    }
    return currentEntry;
}

@end
