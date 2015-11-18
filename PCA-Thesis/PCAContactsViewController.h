//
//  PCAContactsViewController.h
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCADefinitions.h"
#import "Catalyze.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PCAContactsViewController : UIViewController <UITextViewDelegate>

// UI elements
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *doctorImageView;
@property (strong, nonatomic) IBOutlet UIButton *mapButton;
@property (strong, nonatomic) IBOutlet UIButton *callButton;
@property (strong, nonatomic) IBOutlet UIButton *siteButton;
@property (strong, nonatomic) IBOutlet UIButton *messageButton;
@property (strong, nonatomic) IBOutlet UIButton *bioButton;
@property (strong, nonatomic) IBOutlet UIButton *mayoLogo;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)mapButtonPressed:(id)sender;            // user pressed button to map address
- (IBAction)callButtonPressed:(id)sender;           // user pressed button to call phone
- (IBAction)siteButtonPressed:(id)sender;           // user pressed button to view website
- (IBAction)messageButtonPressed:(id)sender;        // user pressed button to send message
- (IBAction)bioButtonPressed:(id)sender;            // user pressed button to view bio
- (IBAction)logoutPressed:(id)sender;               // user pressed button to logout

@property NSString *name, *address, *city, *phone, *site;               // Mayo Clinic attributes
@property NSString *username, *fullName, *email, *bio, *imageURL;       // doctor attributes

@end
