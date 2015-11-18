//
//  PCAEditViewController.m
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import "PCAEditViewController.h"

@interface PCAEditViewController ()

@end

@implementation PCAEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    self.title = self.currentSymptom;
    [self.lastValLabel setText:@"The arrow indicates the current value for this symptom."];
    [self showIndicator:[NSNumber numberWithDouble:self.currentValue]];
    
    switch (self.row)
    {
        case 0:
            break;
        case 1:
            [self.descriptionLabel setText:@"Tap the button that best describes how active you have been."];
            [self.greenButton setTitle:@"Extremely Active" forState:UIControlStateNormal];
            [self.blueButton setTitle:@"Very Active" forState:UIControlStateNormal];
            [self.yellowButton setTitle:@"Somewhat Active" forState:UIControlStateNormal];
            [self.orangeButton setTitle:@"A Little Active" forState:UIControlStateNormal];
            [self.redButton setTitle:@"No Activity" forState:UIControlStateNormal];
            break;
        case 2:
            [self.descriptionLabel setText:@"Tap the button that best describes how nauseous you feel."];
            [self.greenButton setTitle:@"No Nausea" forState:UIControlStateNormal];
            [self.blueButton setTitle:@"A Little Nauseous" forState:UIControlStateNormal];
            [self.yellowButton setTitle:@"Somewhat Nauseous" forState:UIControlStateNormal];
            [self.orangeButton setTitle:@"Very Nauseous" forState:UIControlStateNormal];
            [self.redButton setTitle:@"Extremely Nauseous" forState:UIControlStateNormal];
            break;
        case 3:
            [self.descriptionLabel setText:@"Tap the button that best describes how depressed you feel."];
            [self.greenButton setTitle:@"No Depression" forState:UIControlStateNormal];
            [self.blueButton setTitle:@"A Little Depressed" forState:UIControlStateNormal];
            [self.yellowButton setTitle:@"Somewhat Depressed" forState:UIControlStateNormal];
            [self.orangeButton setTitle:@"Very Depressed" forState:UIControlStateNormal];
            [self.redButton setTitle:@"Extremely Depressed" forState:UIControlStateNormal];
            break;
        case 4:
            [self.descriptionLabel setText:@"Tap the button that best describes how anxious you feel."];
            [self.greenButton setTitle:@"No Anxiety" forState:UIControlStateNormal];
            [self.blueButton setTitle:@"A Little Anxious" forState:UIControlStateNormal];
            [self.yellowButton setTitle:@"Somewhat Anxious" forState:UIControlStateNormal];
            [self.orangeButton setTitle:@"Very Anxious" forState:UIControlStateNormal];
            [self.redButton setTitle:@"Extremely Anxious" forState:UIControlStateNormal];
            break;
        case 5:
            [self.descriptionLabel setText:@"Tap the button that best describes how drowsy you feel."];
            [self.greenButton setTitle:@"No Drowsiness" forState:UIControlStateNormal];
            [self.blueButton setTitle:@"A Little Drowsy" forState:UIControlStateNormal];
            [self.yellowButton setTitle:@"Somewhat Drowsy" forState:UIControlStateNormal];
            [self.orangeButton setTitle:@"Very Drowsy" forState:UIControlStateNormal];
            [self.redButton setTitle:@"Extremely Drowsy" forState:UIControlStateNormal];
            break;
        case 6:
            [self.descriptionLabel setText:@"Tap the button that best describes your appetite."];
            [self.greenButton setTitle:@"Excellent Appetite" forState:UIControlStateNormal];
            [self.blueButton setTitle:@"Good Appetite" forState:UIControlStateNormal];
            [self.yellowButton setTitle:@"Moderate Appetite" forState:UIControlStateNormal];
            [self.orangeButton setTitle:@"Very Little Appetite" forState:UIControlStateNormal];
            [self.redButton setTitle:@"No Appetite" forState:UIControlStateNormal];
            break;
        case 7:
            [self.descriptionLabel setText:@"Tap the button that best describes how weak you feel."];
            [self.greenButton setTitle:@"No Weakness" forState:UIControlStateNormal];
            [self.blueButton setTitle:@"A Little Weak" forState:UIControlStateNormal];
            [self.yellowButton setTitle:@"Somewhat Weak" forState:UIControlStateNormal];
            [self.orangeButton setTitle:@"Very Weak" forState:UIControlStateNormal];
            [self.redButton setTitle:@"Extremely Weak" forState:UIControlStateNormal];
            break;
        case 8:
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

- (IBAction)buttonPressed:(id)sender
{
    // set value according to button user clicked
    if (sender == self.greenButton)
        self.currentValue = 1;
    if (sender == self.blueButton)
        self.currentValue = 2;
    if (sender == self.yellowButton)
        self.currentValue = 3;
    if (sender == self.orangeButton)
        self.currentValue = 4;
    if (sender == self.redButton)
        self.currentValue = 5;
    
    if (self.row == 8)
        [self.symptoms setValue:[NSNumber numberWithDouble:self.currentValue] forKey:@"shortness_of_breath"];
    else
        [self.symptoms setValue:[NSNumber numberWithDouble:self.currentValue] forKey:[self.currentSymptom lowercaseString]];
    [self performSegueWithIdentifier:@"BackToSummarySegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // return to summary view
    if ([[segue identifier] isEqualToString:@"BackToSummarySegue"])
    {
        PCASummaryViewController *vc = [segue destinationViewController];
        vc.symptoms = self.symptoms;
    }
}

@end
