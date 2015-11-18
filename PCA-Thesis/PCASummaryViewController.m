//
//  PCASummaryViewController.m
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import "PCASummaryViewController.h"

@interface PCASummaryViewController ()

@end

@implementation PCASummaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:20.0],NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = size;
    self.navigationController.navigationBar.barTintColor = MAYO_CLINIC_NAVY2;
    
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.returnButton setTitleColor:MAYO_CLINIC_NAVY forState:UIControlStateNormal];
    self.descriptionLabel.textColor = MAYO_CLINIC_NAVY;
    
    UIImage *bgImage = [UIImage imageNamed: @"background-dashboard.png"];       // load image
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

- (IBAction)returnButton:(id)sender
{
    // add the doctors who are permitted to view this entry
    // this is easier for the doctor's view than for doctors to query all users
    NSString* doctor = [[CatalyzeUser currentUser] extraForKey:@"providerId"];
    
    CatalyzeEntry* newEsasEntry = [CatalyzeEntry entryWithClassName:@"esasEntry" dictionary:self.symptoms];
    [newEsasEntry.content setValue:doctor forKey:@"doctor"];
    
    // set timestamp for checking when survey was last submitted
    // http://stackoverflow.com/questions/3917250/converting-nsstring-to-nsdate-and-back-again
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
    NSString *stringDate = [dateFormatter stringFromDate:[NSDate date]];
    [newEsasEntry.content setValue:stringDate forKey:@"timestamp"];
    
    // get count of urgent symptoms
    // symptoms are considered urgent if user clicked ORANGE or RED button (symptom value = 4 or 5)
    double count = 0;
    if ([[self.symptoms valueForKey:@"pain"] integerValue] > 3)
        count++;
    if ([[self.symptoms valueForKey:@"activity"] integerValue] > 3)
        count++;
    if ([[self.symptoms valueForKey:@"nausea"] integerValue] > 3)
        count++;
    if ([[self.symptoms valueForKey:@"depression"] integerValue] > 3)
        count++;
    if ([[self.symptoms valueForKey:@"anxiety"] integerValue] > 3)
        count++;
    if ([[self.symptoms valueForKey:@"drowsiness"] integerValue] > 3)
        count++;
    if ([[self.symptoms valueForKey:@"appetite"] integerValue] > 3)
        count++;
    if ([[self.symptoms valueForKey:@"weakness"] integerValue] > 3)
        count++;
    if ([[self.symptoms valueForKey:@"shortness_of_breath"] integerValue] > 3)
        count++;
    NSLog(@"URGENT SYMPTOMS = %f", count);
    [newEsasEntry.content setValue:[NSNumber numberWithDouble:count] forKey:@"urgent"];
    
    [newEsasEntry createInBackgroundWithSuccess:^(id result)
     { }
     failure:^(NSDictionary *result, int status, NSError *error)
     {
         NSLog(@"Error in saveinBackground, save unsuccessful");
         NSLog(@"error status: %d", status);
         
         for (NSString* key in [result allKeys])
         {
             NSLog(@"%@", [result valueForKey:key]);
         }
         NSLog(@"dictionary:%@", self.symptoms);
     }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"returnSegue"])
    {
        PCADashboardViewController *vc = [segue destinationViewController];     // get destination view
        vc.segueTag = @"return";        // pass tag to destination view
        // lets dashboard know you're returning from the end of the survey
    }
    else if ([[segue identifier] isEqualToString:@"tableSegue"])
    {
        PCATableViewController* vc = [segue destinationViewController];
        vc.symptoms = self.symptoms;
    }
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
