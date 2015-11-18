//
//  PCASettingsViewController.h
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCADefinitions.h"
#import "Catalyze.h"

@interface PCASettingsViewController : UIViewController

// UI elements
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UITextField *warningTextField;
@property (strong, nonatomic) IBOutlet UITextField *urgentTextField;
@property (strong, nonatomic) IBOutlet UIStepper *warningStepper;
@property (strong, nonatomic) IBOutlet UIStepper *urgentStepper;
@property (strong, nonatomic) IBOutlet UISwitch *notifyPhoneSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *notifyDoctorSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *rememberUserSwitch;

- (IBAction)logoutPressed:(id)sender;           // user pressed logout

@end
