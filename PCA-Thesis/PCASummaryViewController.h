//
//  PCASummaryViewController.h
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCADefinitions.h"
#import "Catalyze.h"
#import "PCADashboardViewController.h"
#import "PCATableViewController.h"

@interface PCASummaryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

// UI elements
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *returnButton;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

- (IBAction)returnButton:(id)sender;            // user submitted survey
- (IBAction)logoutPressed:(id)sender;           // user pressed logout

@property NSMutableDictionary* symptoms;        // values for all symptoms

@end
