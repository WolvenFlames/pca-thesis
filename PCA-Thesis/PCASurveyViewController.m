//
//  PCASurveyViewController.m
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import "PCASurveyViewController.h"

@interface PCASurveyViewController ()

@end

@implementation PCASurveyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

/**
 Called after the view loads. Does basic checks and begins cycling through symptom screens
 @return void
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self executeQuery];
    [self.arrowButton setHidden:YES];
    
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:20.0],NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = size;
    self.navigationController.navigationBar.barTintColor = MAYO_CLINIC_NAVY2;
    self.descriptionLabel.textColor = MAYO_CLINIC_NAVY;
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    UIImage *bgImage = [UIImage imageNamed: @"background-survey.png"];       // load image
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
    
    self.symptoms = [[NSMutableDictionary alloc] init];
    self.currentSymptom = 0;
 
    if (![CatalyzeUser currentUser]) //make sure someone is logged in
    {
        [PCADefinitions showAlert:NO_USER_LOGGED_IN];

    }
}

- (IBAction)buttonPressed:(id)sender
{
    // set symptom value according to which button user pressed
    if (sender == self.greenButton)
        self.valueToSave = 1;
    if (sender == self.blueButton)
        self.valueToSave = 2;
    if (sender == self.yellowButton)
        self.valueToSave = 3;
    if (sender == self.orangeButton)
        self.valueToSave = 4;
    if (sender == self.redButton)
        self.valueToSave = 5;
    
    [self updateEntry];         // save the slider/button value to the dictionary
    self.currentSymptom++;      // move on to next symptom
    [self showNextSymptom];
}

/**
 Called before executing a segue. Determines what to show when the patient is done
 @param segue to be executed
 @param sender id of sender
 @return void
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController* destinationNC = segue.destinationViewController;
    PCASummaryViewController* nextVC = [[destinationNC viewControllers] objectAtIndex:0];
    nextVC.symptoms = self.symptoms;
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

/**
 Called to show UI element for next symptom. Moves currentSymptom class variable
 @param start Symptom to start at (if not showing all symptoms)
 @return void
 */
-(void)showNextSymptom
{
    if (self.currentSymptom < OTHER) //if we haven't moved past the array
    {
        [self showSymptomScreen];
    }
    else //if we have moved completely through the array
    {
        NSLog(@"all done, go to new VC");
        [self performSegueWithIdentifier:@"SummarySegue" sender:self];
    }
}

/**
 Entry method for UI element creation and operation for symptom screen.
 @return void
 */
-(void)showSymptomScreen
{
    switch (self.currentSymptom)
    {
        case PAIN:
            [self.descriptionLabel setText:@"Tap the button that best describes your pain level."];
            [self.greenButton setTitle:@"No Pain" forState:UIControlStateNormal];
            [self.blueButton setTitle:@"Low Pain" forState:UIControlStateNormal];
            [self.yellowButton setTitle:@"Moderate Pain" forState:UIControlStateNormal];
            [self.orangeButton setTitle:@"High Pain" forState:UIControlStateNormal];
            [self.redButton setTitle:@"Extreme Pain" forState:UIControlStateNormal];
            break;
        case ACTIVITY:
            [self.descriptionLabel setText:@"Tap the button that best describes how active you have been."];
            [self.greenButton setTitle:@"Extremely Active" forState:UIControlStateNormal];
            [self.blueButton setTitle:@"Very Active" forState:UIControlStateNormal];
            [self.yellowButton setTitle:@"Somewhat Active" forState:UIControlStateNormal];
            [self.orangeButton setTitle:@"A Little Active" forState:UIControlStateNormal];
            [self.redButton setTitle:@"No Activity" forState:UIControlStateNormal];
            break;
        case NAUSEA:
            [self.descriptionLabel setText:@"Tap the button that best describes how nauseous you feel."];
            [self.greenButton setTitle:@"No Nausea" forState:UIControlStateNormal];
            [self.blueButton setTitle:@"A Little Nauseous" forState:UIControlStateNormal];
            [self.yellowButton setTitle:@"Somewhat Nauseous" forState:UIControlStateNormal];
            [self.orangeButton setTitle:@"Very Nauseous" forState:UIControlStateNormal];
            [self.redButton setTitle:@"Extremely Nauseous" forState:UIControlStateNormal];
            break;
        case DEPRESSION:
            [self.descriptionLabel setText:@"Tap the button that best describes how depressed you feel."];
            [self.greenButton setTitle:@"No Depression" forState:UIControlStateNormal];
            [self.blueButton setTitle:@"A Little Depressed" forState:UIControlStateNormal];
            [self.yellowButton setTitle:@"Somewhat Depressed" forState:UIControlStateNormal];
            [self.orangeButton setTitle:@"Very Depressed" forState:UIControlStateNormal];
            [self.redButton setTitle:@"Extremely Depressed" forState:UIControlStateNormal];
            break;
        case ANXIETY:
            [self.descriptionLabel setText:@"Tap the button that best describes how anxious you feel."];
            [self.greenButton setTitle:@"No Anxiety" forState:UIControlStateNormal];
            [self.blueButton setTitle:@"A Little Anxious" forState:UIControlStateNormal];
            [self.yellowButton setTitle:@"Somewhat Anxious" forState:UIControlStateNormal];
            [self.orangeButton setTitle:@"Very Anxious" forState:UIControlStateNormal];
            [self.redButton setTitle:@"Extremely Anxious" forState:UIControlStateNormal];
            break;
        case DROWSINESS:
            [self.descriptionLabel setText:@"Tap the button that best describes how drowsy you feel."];
            [self.greenButton setTitle:@"No Drowsiness" forState:UIControlStateNormal];
            [self.blueButton setTitle:@"A Little Drowsy" forState:UIControlStateNormal];
            [self.yellowButton setTitle:@"Somewhat Drowsy" forState:UIControlStateNormal];
            [self.orangeButton setTitle:@"Very Drowsy" forState:UIControlStateNormal];
            [self.redButton setTitle:@"Extremely Drowsy" forState:UIControlStateNormal];
            break;
        case APPETITE:
            [self.descriptionLabel setText:@"Tap the button that best describes your appetite."];
            [self.greenButton setTitle:@"Excellent Appetite" forState:UIControlStateNormal];
            [self.blueButton setTitle:@"Good Appetite" forState:UIControlStateNormal];
            [self.yellowButton setTitle:@"Moderate Appetite" forState:UIControlStateNormal];
            [self.orangeButton setTitle:@"Very Little Appetite" forState:UIControlStateNormal];
            [self.redButton setTitle:@"No Appetite" forState:UIControlStateNormal];
            break;
        case WEAKNESS:
            [self.descriptionLabel setText:@"Tap the button that best describes how weak you feel."];
            [self.greenButton setTitle:@"No Weakness" forState:UIControlStateNormal];
            [self.blueButton setTitle:@"A Little Weak" forState:UIControlStateNormal];
            [self.yellowButton setTitle:@"Somewhat Weak" forState:UIControlStateNormal];
            [self.orangeButton setTitle:@"Very Weak" forState:UIControlStateNormal];
            [self.redButton setTitle:@"Extremely Weak" forState:UIControlStateNormal];
            break;
        case SHORTNESS_OF_BREATH:
            [self.descriptionLabel setText:@"Tap the button that best describes your ability to breathe."];
            [self.greenButton setTitle:@"No Difficulty Breathing" forState:UIControlStateNormal];
            [self.blueButton setTitle:@"A Little Difficult" forState:UIControlStateNormal];
            [self.yellowButton setTitle:@"Somewhat Difficult" forState:UIControlStateNormal];
            [self.orangeButton setTitle:@"Very Difficult" forState:UIControlStateNormal];
            [self.redButton setTitle:@"Extremely Difficult" forState:UIControlStateNormal];
            break;
        default:
            [self.descriptionLabel setText:@"Tap the button that best describes how you feel."];
            [self.greenButton setTitle:@"Button" forState:UIControlStateNormal];
            [self.blueButton setTitle:@"Button" forState:UIControlStateNormal];
            [self.yellowButton setTitle:@"Button" forState:UIControlStateNormal];
            [self.orangeButton setTitle:@"Button" forState:UIControlStateNormal];
            [self.redButton setTitle:@"Button" forState:UIControlStateNormal];
            break;
    }
    
    NSNumber* lastVal = [self.mostRecent.content valueForKey:[PCADefinitions determineSymptomName:self.currentSymptom]];
    if (self.currentSymptom == SHORTNESS_OF_BREATH)
        lastVal = [self.mostRecent.content valueForKey:@"shortness_of_breath"];
    NSLog(@"last value = %@", lastVal);
    
    if (lastVal == NULL)        // if this is the user's first time taking the survey
        [self.lastValLabel setText:@""];
    else
    {
        [self.lastValLabel setText:@"The arrow indicates the last value you entered."];
        [self showIndicator:lastVal];
    }
    
    NSString* symptomName = [PCADefinitions determineSymptomName:self.currentSymptom]; //determine which symptom we're on
    
    self.title = [symptomName capitalizedString]; //change the VC title
    if (self.currentSymptom == SHORTNESS_OF_BREATH)
        self.title = @"Breathing";
}

/**
 Method used to create and place image view to show previously entered value
 */
-(void) showIndicator: (NSNumber*) value
{
    NSArray* subViews = [self.view subviews];
    for (UIView* v in subViews)
    {
        if ([v isOpaque])
            [v removeFromSuperview];
    }

    [self.arrowButton setHidden:NO];            // make sure arrow is visible
    CGRect frame = self.arrowButton.frame;      // get its frame
    switch ([value integerValue])
    {
        case 1:
            frame.origin.y = self.greenButton.frame.origin.y + 15;
            break;
        case 2:
            frame.origin.y = self.blueButton.frame.origin.y + 15;
            break;
        case 3:
            frame.origin.y = self.yellowButton.frame.origin.y + 15;
            break;
        case 4:
            frame.origin.y = self.orangeButton.frame.origin.y + 15;
            break;
        case 5:
            frame.origin.y = self.redButton.frame.origin.y + 15;
            break;
        default:
            frame.origin.y = 1000;
            break;
    }
    
    self.arrowButton.frame = frame;     // apply new frame
}

/**
 Called when user continues through confirmation popup. Updates the symptoms.
 @return void
 @warning Note: this does NOT save the dictionary to the backend
 */
-(void) updateEntry
{
    NSLog(@"save data: %.1f", self.valueToSave);

    if (self.currentSymptom == SHORTNESS_OF_BREATH) //special case--different name in schema due to underscores
    {
        [self.symptoms setValue:[NSNumber numberWithDouble:self.valueToSave] forKey:@"shortness_of_breath"];
    }
    else //all other values in Catalyze esasEntry class have the same name as the determineSymptomName value
    {
        [self.symptoms setValue:[NSNumber numberWithDouble:self.valueToSave] forKey:[PCADefinitions determineSymptomName:self.currentSymptom]];
    }
    NSLog(@"%@", self.symptoms);
}

/**
 Called before all done segue. Creates the esasEntry and saves it to the backend
 @return void
 */
-(void) saveEntryToCatalyze
{
    
    //then, add the doctors who are permitted to view this entry
    //this is easier for the doctor's view than for doctors to query all users
    NSString* doctor = [[CatalyzeUser currentUser] extraForKey:@"providerId"];
    
    CatalyzeEntry* newEsasEntry = [CatalyzeEntry entryWithClassName:@"esasEntry" dictionary:self.symptoms];
    [newEsasEntry.content setValue:doctor forKey:@"doctor"];
    
    [newEsasEntry createInBackgroundWithSuccess:^(id result)
    {
        //all done, move on
        [self performSegueWithIdentifier:@"SummarySegue" sender:self];
    }
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
            self.surveys = result;          // populate array with all surveys submitted
            self.mostRecent = [self findMostRecent:result];         // get most recent survey
            
            [self showNextSymptom];     // start survey
        }
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

@end
