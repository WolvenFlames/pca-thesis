//
//  PCATableViewController.m
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import "PCATableViewController.h"

@interface PCATableViewController ()

@end

@implementation PCATableViewController

NSArray *tableData;     // holds list of symptoms
NSArray *data;          // holds list of values user entered

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    // initialize list of symptoms
    tableData = [NSArray arrayWithObjects:@"Pain", @"Activity", @"Nausea", @"Depression", @"Anxiety", @"Drowsiness", @"Appetite", @"Weakness", @"Breathing", nil];
    
    data = [NSArray arrayWithObjects:[self.symptoms valueForKey:@"pain"], [self.symptoms valueForKey:@"activity"], [self.symptoms valueForKey:@"nausea"], [self.symptoms valueForKey:@"depression"], [self.symptoms valueForKey:@"anxiety"], [self.symptoms valueForKey:@"drowsiness"], [self.symptoms valueForKey:@"appetite"], [self.symptoms valueForKey:@"weakness"], [self.symptoms valueForKey:@"shortness_of_breath"], nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"TableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    NSInteger value = [[data objectAtIndex:indexPath.row] integerValue];
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
    // height of each table row
    return 39;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // when user clicks on a row, get values from that row
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.symptom = cell.textLabel.text;
    self.value = [[data objectAtIndex:indexPath.row] doubleValue];
    self.row = indexPath.row;
    [self performSegueWithIdentifier:@"CellSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // send info to editor view controller
    if ([[segue identifier] isEqualToString:@"CellSegue"])
    {
        PCAEditViewController *vc = [segue destinationViewController];     // get destination view
        vc.symptoms = self.symptoms;
        vc.row = self.row;
        vc.currentSymptom = self.symptom;
        vc.currentValue = self.value;
    }
}

@end
