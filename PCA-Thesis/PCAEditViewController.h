//
//  PCAEditViewController.h
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCADefinitions.h"
#import "Catalyze.h"
#import "PCASummaryViewController.h"

@interface PCAEditViewController : UIViewController

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

@property NSMutableDictionary* symptoms;        // values for all symptoms
@property NSInteger row;                        // row of current symptom
@property NSString *currentSymptom;             // name of current symptom
@property double currentValue;                  // value of current symptom

@end
