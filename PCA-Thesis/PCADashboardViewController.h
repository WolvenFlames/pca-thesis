//
//  PCADashboardViewController.h
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCADefinitions.h"
#import "Catalyze.h"
#import "PCAHistoryViewController.h"
#import "PCAProfileViewController.h"
#import "PCASettingsViewController.h"
#import "PCAContactsViewController.h"

@interface PCADashboardViewController : UIViewController

// UI elements
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *alertButton;
@property (strong, nonatomic) IBOutlet UILabel *alertLabel;

- (IBAction)profileButton:(id)sender;       // user pressed button to view Profile
- (IBAction)historyButton:(id)sender;       // user pressed button to view History
- (IBAction)contactsButton:(id)sender;      // user pressed button to view Contacts
- (IBAction)settingsButton:(id)sender;      // user pressed button to view Settings
- (IBAction)surveyButton:(id)sender;        // user pressed button to start survey
- (IBAction)logoutPressed:(id)sender;       // user pressed logout

@property NSArray* surveys;                 // array of all submitted surveys
@property CatalyzeEntry* mostRecent;        // most recent survey submitted
@property NSDateComponents *components;     // date components representing time since last survey
@property NSDate *lastSurvey;               // date of most recent survey
@property NSString *firstDate;              // date of first survey every taken
@property NSString* segueTag;               // for determining when returning from survey

@end
