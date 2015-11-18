//
//  PCASignupViewController.h
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCADefinitions.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "Catalyze.h"

@interface PCASignupViewController : UIViewController

// UI elements
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField2;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *idField;
@property (weak, nonatomic) IBOutlet UITextField *zipField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderControl;

- (IBAction)cancelPressed:(id)sender;       // user pressed cancel button
- (IBAction)signupPressed:(id)sender;       // user confirmed sign up

@end
