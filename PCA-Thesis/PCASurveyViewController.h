//
//  PCASurveyViewController.h
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Catalyze.h"
#import "PCADefinitions.h"
#import "PCASummaryViewController.h"

@interface PCASurveyViewController : UIViewController <UIAlertViewDelegate>

// UI elements
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *greenButton;
@property (strong, nonatomic) IBOutlet UIButton *blueButton;
@property (strong, nonatomic) IBOutlet UIButton *yellowButton;
@property (strong, nonatomic) IBOutlet UIButton *orangeButton;
@property (strong, nonatomic) IBOutlet UIButton *redButton;
@property (strong, nonatomic) IBOutlet UIButton *arrowButton;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastValLabel;

- (IBAction)buttonPressed:(id)sender;           // user pressed a survey button
- (IBAction)logoutPressed:(id)sender;           // user pressed logout

@property NSArray* surveys;                     // array of all submitted surveys
@property NSMutableDictionary* symptoms;        // values for all symptoms
@property CatalyzeEntry* mostRecent;            // most recent survey submitted
@property int currentSymptom;                   // keeps track of which symptom we're on
@property double valueToSave;                   // value corresponding to button clicked by user

@end
