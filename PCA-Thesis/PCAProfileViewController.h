//
//  PCAProfileViewController.h
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCADefinitions.h"
#import "Catalyze.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>
@import AssetsLibrary;

@interface PCAProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// UI elements
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *surveyLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *photoDescription;
@property (strong, nonatomic) IBOutlet UIButton *photoButton;

- (IBAction)changePhoto:(id)sender;         // user clicked button to change photo
- (IBAction)logoutPressed:(id)sender;       // user pressed logout

@property NSUInteger count;                 // total number of surveys user has taken
@property NSDateComponents *components;     // date components representing time since last survey
@property NSString *firstDate;              // date of first survey user ever submitted

@end
