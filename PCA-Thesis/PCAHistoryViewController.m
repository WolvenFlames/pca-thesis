//
//  PCAHistoryViewController.m
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import "PCAHistoryViewController.h"

@interface PCAHistoryViewController ()

@end

@implementation PCAHistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.newerButton setHidden:YES];       // hide newer button because we're viewing first entry
    if ([self.surveys count] < 2)
        [self.olderButton setHidden:YES];
    
    self.currentEntry = [self.surveys objectAtIndex:self.currentIndex];
    if (self.currentEntry != NULL)
        [self.dateLabel setText:self.timestamp];
    
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:20.0],NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = size;
    self.navigationController.navigationBar.barTintColor = MAYO_CLINIC_NAVY2;
    
    self.title = @"History";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    UIImage *bgImage = [UIImage imageNamed: @"background-history.png"];       // load image
    self.backgroundImageView = [[UIImageView alloc] initWithImage:bgImage];     // initialize image view with image
    [self.backgroundImageView sizeToFit];                           // scale image to fit frame
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    CGRect frame = self.backgroundImageView.frame;
    float imgFactor = frame.size.height / frame.size.width;         // configure frame settings
    frame.size.width = [[UIScreen mainScreen] bounds].size.width;
    frame.size.height = frame.size.width * imgFactor;
    self.backgroundImageView.frame = frame;
    [self.view addSubview:self.backgroundImageView];            // add image view as subview to main view
    [self.view sendSubviewToBack:self.backgroundImageView];     // send image to background so it doesn't cover objects
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"historyTableSegue"])
    {
        PCAHistoryTableViewController *vc = [segue destinationViewController];     // get destination view
        vc.currentEntry = [self.surveys objectAtIndex:self.currentIndex];
    }
}

- (IBAction)newerButtonPressed:(id)sender
{
    [self.olderButton setHidden:NO];        // now that we're not viewing oldest entry, unhide "older" arrow
    
    self.currentIndex--;
    if (self.currentIndex == 0)
        [self.newerButton setHidden:YES];
    
    self.currentEntry = [self.surveys objectAtIndex:self.currentIndex];
    NSString *dateString = [self.currentEntry.content valueForKey:@"timestamp"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
    NSDate *newDate = [[NSDate alloc] init];
    newDate = [dateFormatter dateFromString:dateString];      // get date from stored timestamp
    [dateFormatter setDateFormat:@"MMMM d, yyyy h:mm:ss a"];
    [self.dateLabel setText:[dateFormatter stringFromDate:newDate]];    // revert back to timestamp and display
    
    // RELOAD TABLE WITH NEW ENTRY
    PCAHistoryTableViewController *vc = (PCAHistoryTableViewController *)self.childViewControllers[0];
    vc.currentEntry = self.currentEntry;
    [vc viewDidLoad];       // manually reload table view controller
}

- (IBAction)olderButtonPressed:(id)sender
{
    [self.newerButton setHidden:NO];        // now that we're not viewing newest entry, unhide "newer" arrow
    
    self.currentIndex++;
    if (self.currentIndex == [self.surveys count] - 1)
        [self.olderButton setHidden:YES];
    
    self.currentEntry = [self.surveys objectAtIndex:self.currentIndex];
    NSString *dateString = [self.currentEntry.content valueForKey:@"timestamp"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
    NSDate *newDate = [[NSDate alloc] init];
    newDate = [dateFormatter dateFromString:dateString];      // get date from stored timestamp
    [dateFormatter setDateFormat:@"MMMM d, yyyy h:mm:ss a"];
    [self.dateLabel setText:[dateFormatter stringFromDate:newDate]];    // revert back to timestamp and display
    
    // RELOAD TABLE WITH NEW ENTRY
    PCAHistoryTableViewController *vc = (PCAHistoryTableViewController *)self.childViewControllers[0];
    vc.currentEntry = self.currentEntry;
    [vc viewDidLoad];       // manually reload table view controller
}


// THESE ARE ONLY PLACEHOLDER FUNCTIONS TO GET RID OF THE WARNINGS
// SEE PCAHistoryTableViewController.m FOR THE ACTUAL FUNCTIONS
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   return 0;   }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   UITableViewCell *cell;  return cell;    }


/**
 Called when the user presses the logout button. Sends the user back to the login screen and disengages Catalyze
 @param sender id of the pressed button
 @return IBAction
 */
- (IBAction)logoutPressed:(id)sender
{
    [[CatalyzeUser currentUser] logoutWithSuccess:^(id result)
     {
         // dismiss modal stack
         UIViewController *vc = self.presentingViewController;
         while (vc.presentingViewController)
             vc = vc.presentingViewController;
         [vc dismissViewControllerAnimated:YES completion:NULL];
     }
                                          failure:^(NSDictionary *result, int status, NSError *error)
     {
         NSLog(@"Error while logging out");
         [PCADefinitions showAlert:LOGOUT_ERROR];
     }];
}

@end
