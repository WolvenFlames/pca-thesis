//
//  PCADashboardViewController.m
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import "PCADashboardViewController.h"

@interface PCADashboardViewController ()

@end

@implementation PCADashboardViewController

- (void)viewWillAppear:(BOOL)animated
{
    // force view controller to reload even when going back from other views
    // the dashboard passes info to other pages, so that info needs to be updated
    // only do it when we're NOT returning from the survey
    if (![self.segueTag isEqualToString:@"return"])
        [self viewDidLoad];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.alertButton setHidden:true];
    [self.alertLabel setHidden:true];
    [self executeQuery];        // get all surveys
    
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:20.0],NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = size;
    self.navigationController.navigationBar.barTintColor = MAYO_CLINIC_NAVY2;
    
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    self.alertButton.userInteractionEnabled = NO;
    self.alertButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
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
    
    // indicates that user just completed survey and is returning to dashboard
    if ([self.segueTag isEqualToString:@"return"])
    {
        // need to set a local notification for 3 days from now
        // if user does not take survey within 3 days, they will be alerted
        // REFERENCE: http://stackoverflow.com/questions/9232490/how-do-i-create-and-cancel-unique-uilocalnotification-from-a-custom-class
    
        // this notification fires immediately
        UILocalNotification *alert = [[UILocalNotification alloc] init];
        alert.fireDate = [NSDate date];
        alert.applicationIconBadgeNumber = -1;      // resets the icon badge number so the "1" no longer displays
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"alert" forKey:@"key"];
        alert.userInfo = userInfo;
        [[UIApplication sharedApplication] scheduleLocalNotification:alert];
    
        // delete any alerts that have already been scheduled
        for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy])
        {
            NSDictionary *userInfo = notification.userInfo;
            if ([[userInfo objectForKey:@"key"] isEqualToString:@"alert"])      // every notification matches, deletes all
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
        
        // need to check whether user has turned phone notifications on
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        double urgent = [defaults doubleForKey:@"urgent"];      // number of days until alert fires
        if (urgent < 1 || urgent > 14)
            urgent = 3;
        
        if ([defaults boolForKey:@"notifyPhone"])
        {
            alert = [[UILocalNotification alloc] init];
            alert.alertBody = @"URGENT:  You have been inactive for too long.  Please log in as soon as possible.";
            alert.fireDate = [NSDate dateWithTimeInterval:(60 * 60 * 24 * urgent) sinceDate:[NSDate date]];
            alert.soundName = UILocalNotificationDefaultSoundName;
            alert.applicationIconBadgeNumber = 1;
            alert.userInfo = userInfo;
            [[UIApplication sharedApplication] scheduleLocalNotification:alert];
            NSLog(@"Notification scheduled for %.02f days from now.", urgent);
        }
    }
    
    [self.view bringSubviewToFront:self.alertLabel];
}

- (IBAction)profileButton:(id)sender
{
    NSLog(@"Profile");
}

- (IBAction)historyButton:(id)sender
{
    NSLog(@"History");
}

- (IBAction)contactsButton:(id)sender
{
    NSLog(@"Contacts");
}

- (IBAction)settingsButton:(id)sender
{
    NSLog(@"Settings");
}

- (IBAction)surveyButton:(id)sender
{
    NSLog(@"Survey");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"historySegue"])
    {
        PCAHistoryViewController *vc = [segue destinationViewController];     // get destination view
        
        // reverse array of entries such that most recent entry is first
        vc.surveys = [[self.surveys reverseObjectEnumerator] allObjects];
        
        // set current index to 0 (first entry)
        vc.currentIndex = 0;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM d, yyyy h:mm:ss a"];
        vc.timestamp = [dateFormatter stringFromDate:self.lastSurvey];
    }
    else if ([[segue identifier] isEqualToString:@"profileSegue"])
    {
        PCAProfileViewController *vc = [segue destinationViewController];     // get destination view
        vc.count = [self.surveys count];
        vc.components = self.components;
        vc.firstDate = self.firstDate;
    }
}

/**
 Queries the last 60 user entries
 Stores all 60 for use in statistics later
 Finds and stores most recent for use showing previous value
 Begins the symptom UI cycle
 */
-(void) executeQuery
{
    CatalyzeQuery* query = [CatalyzeQuery queryWithClassName:@"esasEntry"];
    [query setPageNumber:1];
    [query setPageSize:1000];
    
    [query retrieveInBackgroundForUsersId:[[CatalyzeUser currentUser] usersId] success:^(NSArray *result)
     {
         if ([result count] > 0)
         {
             self.surveys = result;
             self.mostRecent = [self findMostRecent:result];
             
             // SOURCE: http://stackoverflow.com/questions/3917250/converting-nsstring-to-nsdate-and-back-again
             NSString *dateString = [self.mostRecent.content valueForKey:@"timestamp"];
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
             NSDate *startDate = [[NSDate alloc] init];
             startDate = [dateFormatter dateFromString:dateString];
             self.lastSurvey = startDate;       // for sending to history view controller
             NSDate *endDate = [NSDate date];
             
             // get first survey ever taken (sending to profile view)
             CatalyzeEntry *entry = [self.surveys firstObject];
             NSDate *firstSurvey = [[NSDate alloc] init];
             firstSurvey = [dateFormatter dateFromString:[entry.content valueForKey:@"timestamp"]];
             [dateFormatter setDateFormat:@"MMMM d, yyyy' at 'h:mm:ss a"];
             self.firstDate = [dateFormatter stringFromDate:firstSurvey];    // new date format
             
             // SOURCE: http://stackoverflow.com/questions/8387360/get-an-accurate-time-difference-between-two-nsdates
             NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
             NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit |NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
             self.components = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];
             
             NSLog(@"TIME SINCE LAST SURVEY:");
             NSLog(@"Years = %ld", (long)[self.components year]);
             NSLog(@"Months = %ld", (long)[self.components month]);
             NSLog(@"Days = %ld", (long)[self.components day]);
             NSLog(@"Hours = %ld", (long)[self.components hour]);
             NSLog(@"Minutes = %ld", (long)[self.components minute]);
             
             // need to check user's preferred values
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             double urgent = [defaults doubleForKey:@"urgent"];     // this will return something like 3.5
             float uDay = floorf(urgent);                           // determine 3 days
             float uHour = (urgent - uDay) * 24;                    // determine 12 hours
             double warning = [defaults doubleForKey:@"warning"];
             float wDay = floorf(warning);
             float wHour = (warning - wDay) * 24;
             NSLog(@"Warning = %f days %f hours ... Urgent = %f days %f hours.", wDay, wHour, uDay, uHour);
             
             // URGENT -- if patient has not taken survey within 72 hours
             if ([self.components year] > 0 || [self.components month] > 0 || [self.components day] > uDay || ([self.components day] == uDay && [self.components hour] >= uHour))
             {
                 [self.alertButton setBackgroundImage:[UIImage imageNamed:@"alert-urgent.png"] forState:UIControlStateNormal];
                 [self.alertButton setTitle:@"URGENT" forState:UIControlStateNormal];
                 [self.alertLabel setText:@"Please complete right away!"];
             }
             else
             {
                 // WARNING -- it has been more than 36 hours, but less than 72 hours
                 if ([self.components day] > wDay || ([self.components day] == wDay && [self.components hour] >= wHour))
                 {
                     [self.alertButton setBackgroundImage:[UIImage imageNamed:@"alert-warning.png"] forState:UIControlStateNormal];
                     [self.alertButton setTitle:@"WARNING" forState:UIControlStateNormal];
                     [self.alertLabel setText:@"Please complete soon."];
                 }
                 // UP TO DATE -- if patient has taken survey within 36 hours
                 else
                 {
                     [self.alertButton setBackgroundImage:[UIImage imageNamed:@"alert-uptodate.png"] forState:UIControlStateNormal];
                     [self.alertButton setTitle:@"UP TO DATE" forState:UIControlStateNormal];
                     [self.alertLabel setText:@"No action required."];
                 }
             }
         }
         else
         {
             // user has never taken survey before
             [self.alertButton setBackgroundImage:[UIImage imageNamed:@"alert-warning.png"] forState:UIControlStateNormal];
             [self.alertButton setTitle:@"WARNING" forState:UIControlStateNormal];
             [self.alertLabel setText:@"Please complete soon."];
         }
         [self.alertButton setHidden:false];
         [self.alertLabel setHidden:false];
     }
                                  failure:^(NSDictionary *result, int status, NSError *error)
     {
         NSLog(@"query failure in queryforstatistics");
         NSLog(@"%@", error);
     }];
}

/**
 Finds the most recent entry in the query results
 @param result NSArray returned by Catalyze query function
 @return CatalyzeEntry* most recent entry
 */
-(CatalyzeEntry*) findMostRecent:(NSArray*) result
{
    CatalyzeEntry* mostRecent = result[0];
    
    for (CatalyzeEntry* entry in result)
    {
        NSComparisonResult comp = [mostRecent.createdAt compare:entry.createdAt];
        if (comp == NSOrderedAscending)
        {
            mostRecent = entry;
        }
        //else, leave it--doesn’t matter
    }
    return mostRecent;
}

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
