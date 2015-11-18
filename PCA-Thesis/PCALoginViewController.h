//
//  PCAViewController.h
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Catalyze.h"
#import "PCADefinitions.h"
#import "PCAPatientTableViewController.h"

@interface PCALoginViewController : UIViewController

// UI elements
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *mayoLogo;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;
@property (strong, nonatomic) IBOutlet UIButton *forgotPasswordButton;

- (IBAction)loginPressed:(id)sender;            // user pressed login button
- (IBAction)signupPressed:(id)sender;           // user pressed sign up button
- (IBAction)forgotPasswordPressed:(id)sender;   // user pressed forgot password button

@end
