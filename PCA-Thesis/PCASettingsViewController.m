//
//  PCASettingsViewController.m
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import "PCASettingsViewController.h"

@interface PCASettingsViewController ()

@end

@implementation PCASettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // if applicable, get previously stored settings from NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    double warning = [defaults doubleForKey:@"warning"];
    double urgent = [defaults doubleForKey:@"urgent"];
    if (warning != 0)
        [self.warningStepper setValue:warning];
    else
        [self.warningStepper setValue:1.5];         // default warning time = 1.5 days
    if (urgent != 0)
        [self.urgentStepper setValue:urgent];
    else
        [self.urgentStepper setValue:3];            // default warning time = 3 days
    [self.notifyPhoneSwitch setOn:[defaults boolForKey:@"notifyPhone"]];
    [self.notifyDoctorSwitch setOn:[defaults boolForKey:@"notifyDoctor"]];
    [self.rememberUserSwitch setOn:[defaults boolForKey:@"rememberUser"]];
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    [self.warningTextField setText:[fmt stringFromNumber:[NSNumber numberWithFloat:self.warningStepper.value]]];
    [self.urgentTextField setText:[fmt stringFromNumber:[NSNumber numberWithFloat:self.urgentStepper.value]]];
    
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:20.0],NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = size;
    self.navigationController.navigationBar.barTintColor = MAYO_CLINIC_NAVY2;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.warningStepper setTintColor:[UIColor colorWithRed:33.0/255.0 green:134.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [self.urgentStepper setTintColor:[UIColor colorWithRed:33.0/255.0 green:134.0/255.0 blue:255.0/255.0 alpha:1.0]];
    
    UIImage *bgImage = [UIImage imageNamed: @"background-dashboard.png"];       // load image
    self.backgroundImageView = [[UIImageView alloc] initWithImage:bgImage];     // initialize image view with image
    [self.backgroundImageView sizeToFit];                           // scale image to fit frame
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    CGRect frame = self.backgroundImageView.frame;
    float imgFactor = frame.size.height / frame.size.width;         // configure frame settings
    frame.size.width = [[UIScreen mainScreen] bounds].size.width;
    frame.size.height = frame.size.width * imgFactor;
    frame.origin.y = 80;
    self.backgroundImageView.frame = frame;
    [self.view addSubview:self.backgroundImageView];            // add image view as subview to main view
    [self.view sendSubviewToBack:self.backgroundImageView];     // send image to background so it doesn't cover objects
}

- (IBAction)switchChanged:(UISwitch *)sender
{
    // overwrite stored user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.notifyPhoneSwitch.on forKey:@"notifyPhone"];
    [defaults setBool:self.notifyDoctorSwitch.on forKey:@"notifyDoctor"];
    [defaults setBool:self.rememberUserSwitch.on forKey:@"rememberUser"];
    if (self.rememberUserSwitch.on)
        [defaults setValue:[[CatalyzeUser currentUser] username] forKey:@"username"];
    else
        [defaults setValue:@"" forKey:@"username"];
    [defaults synchronize];
}

- (IBAction)valueChanged:(UIStepper *)sender
{
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    
    if (sender == self.warningStepper)
    {
        [self.warningTextField setText:[fmt stringFromNumber:[NSNumber numberWithFloat:self.warningStepper.value]]];
        
        // ensure that urgent value is at least 6 hours greater than warning value
        if (self.warningStepper.value >= self.urgentStepper.value)
        {
            [self.urgentStepper setValue:(self.warningStepper.value + 0.25)];
            [self.urgentTextField setText:[fmt stringFromNumber:[NSNumber numberWithFloat:self.urgentStepper.value]]];
        }
    }
    else
    {
        [self.urgentTextField setText:[fmt stringFromNumber:[NSNumber numberWithFloat:self.urgentStepper.value]]];
        
        // ensure that urgent value is at least 6 hours greater than warning value
        if (self.warningStepper.value >= self.urgentStepper.value)
        {
            [self.warningStepper setValue:(self.urgentStepper.value - 0.25)];
            [self.warningTextField setText:[fmt stringFromNumber:[NSNumber numberWithFloat:self.warningStepper.value]]];
        }
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:self.warningStepper.value forKey:@"warning"];     // overwrite stored user defaults
    [defaults setDouble:self.urgentStepper.value forKey:@"urgent"];
    [defaults synchronize];
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
