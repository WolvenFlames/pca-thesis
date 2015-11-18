//
//  PCAHistoryViewController.h
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCADefinitions.h"
#import "Catalyze.h"
#import "PCAHistoryTableViewController.h"

@interface PCAHistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

// UI elements
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *newerButton;
@property (strong, nonatomic) IBOutlet UIButton *olderButton;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

- (IBAction)newerButtonPressed:(id)sender;      // user pressed button to view next newest survey
- (IBAction)olderButtonPressed:(id)sender;      // user pressed button to view next oldest survey
- (IBAction)logoutPressed:(id)sender;           // user pressed logout

@property NSArray* surveys;                     // array of all submitted surveys
@property CatalyzeEntry* currentEntry;          // survey we're currently viewing
@property int currentIndex;                     // index of survey we're currently viewing
@property NSString *timestamp;                  // date survey was submitted

@end
