//
//  PCAContactsViewController.m
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import "PCAContactsViewController.h"

@interface PCAContactsViewController ()

@end

@implementation PCAContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // need a scrollView for convenience purposes -- so keyboard doesn't block content
    [self.scrollView setShowsVerticalScrollIndicator:YES];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setUserInteractionEnabled:YES];
    [self.view addSubview:self.scrollView];
    [self.scrollView setContentSize:CGSizeMake(320,816)];       // extra 248 for scrolling
    
    // add all UI elements to scrollView
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.addressLabel];
    [self.scrollView addSubview:self.cityLabel];
    [self.scrollView addSubview:self.nameLabel];
    [self.scrollView addSubview:self.emailLabel];
    [self.scrollView addSubview:self.messageTextView];
    [self.scrollView addSubview:self.mapButton];
    [self.scrollView addSubview:self.siteButton];
    [self.scrollView addSubview:self.callButton];
    [self.scrollView addSubview:self.messageButton];
    [self.scrollView addSubview:self.bioButton];
    [self.scrollView addSubview:self.mayoLogo];
    
    // NOTE: THIS INFORMATION IS CURRENTLY HARD-CODED
    // should be getting this data from stored info in Catalyze
    // need to connect patient profile up to doctor profile first
    
    // MAYO CLINIC INFO
    self.name = @"Mayo Clinic Hospital";
    self.address = @"5777 E Mayo Blvd.";
    self.city = @"Phoenix, AZ - 85054";
    self.phone = @"4805156296";
    self.site = @"http://www.mayoclinic.org/patient-visitor-guide/arizona/";
    // DOCTOR INFO
    self.username = @"drlipinski";
    self.fullName = @"Dr. Christopher Lipinski, MD";
    self.email = @"lipinski.christopher@mayo.edu";
    self.bio = @"http://www.mayoclinic.org/biographies/lipinski-christopher-a-m-d/bio-20054463";
    self.imageURL = @"lipinski-bio.jpg";
    
    //-------------------------------------------------
    
    self.titleLabel.text = self.name;
    self.addressLabel.text = self.address;
    self.cityLabel.text = self.city;
    self.nameLabel.text = self.fullName;
    self.emailLabel.text = self.email;
    
    self.messageTextView.delegate = self;
    self.messageTextView.text = @"enter text here...";
    self.messageTextView.textColor = [UIColor lightGrayColor];
    // SOURCE: http://stackoverflow.com/questions/1824463/how-to-style-uitextview-to-like-rounded-rect-text-field
    [self.messageTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.messageTextView.layer setBorderWidth:2.0];        // rounded borders similar to UITextField
    self.messageTextView.layer.cornerRadius = 5;
    self.messageTextView.clipsToBounds = YES;
    
    [self.doctorImageView setImage:[UIImage imageNamed:self.imageURL]];
    self.doctorImageView.frame = CGRectMake(20, 383, 95, 114);
    [self.scrollView addSubview:self.doctorImageView];
    self.view.backgroundColor = MAYO_CLINIC_NAVY;
    
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:20.0],NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = size;
    self.navigationController.navigationBar.barTintColor = MAYO_CLINIC_NAVY2;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    UIImage *bgImage = [UIImage imageNamed: @"background-login.png"];       // load image
    self.backgroundImageView = [[UIImageView alloc] initWithImage:bgImage];     // initialize image view with image
    [self.backgroundImageView sizeToFit];                           // scale image to fit frame
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    CGRect frame = self.backgroundImageView.frame;
    float imgFactor = frame.size.height / frame.size.width;         // configure frame settings
    frame.size.width = [[UIScreen mainScreen] bounds].size.width;
    frame.size.height = frame.size.width * imgFactor;
    self.backgroundImageView.frame = frame;
    [self.scrollView addSubview:self.backgroundImageView];
    [self.scrollView sendSubviewToBack:self.backgroundImageView];     // send image to background so it doesn't cover objects
}

- (IBAction)mapButtonPressed:(id)sender
{
    // SOURCES: http://stackoverflow.com/questions/12504294/programmatically-open-maps-app-in-ios-6
    // http://stackoverflow.com/questions/18563084/how-to-get-lat-and-long-coordinates-from-address-string
    
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // create maps item to pass to maps app
        NSString *address = [NSString stringWithFormat:@"%@ %@", self.address, self.city];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:address
            completionHandler:^(NSArray* placemarks, NSError* error)
            {
                if (placemarks && placemarks.count > 0)
                {
                    CLPlacemark *topResult = [placemarks objectAtIndex:0];
                    MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                    [mapItem setName:@"Mayo Clinic"];
                    [mapItem openInMapsWithLaunchOptions:nil];      // opens map app
                }
            }
        ];
    }
}

- (IBAction)callButtonPressed:(id)sender
{
    // opens phone app and dials number
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.phone]]];
}

- (IBAction)siteButtonPressed:(id)sender
{
    // opens website in Safari
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.site]];
}

- (IBAction)messageButtonPressed:(id)sender
{
    // get text from textfield and send to doctor's account
    // THIS IS CURRENTLY NOT FUNCTIONAL UNTIL INTER-APP MESSAGING GETS SET UP
    // doctor should be able to log in TO THE APP and view patients' messages
    
    // make sure that user has entered text in box
    if (![self.messageTextView.text isEqualToString:@""] && ![self.messageTextView.text isEqualToString:@"enter text here..."])
    {
        // do stuff
        NSLog(@"send message:\n%@", self.messageTextView.text);
    }
}

- (IBAction)bioButtonPressed:(id)sender
{
    // opens website in Safari
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.bio]];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // user began editing textview
    if ([textView.text isEqualToString:@"enter text here..."])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // user stopped editing textview
    if ([textView.text isEqualToString:@""])
    {
        textView.text = @"enter text here...";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

/**
 Called when the user presses the logout button. Sends the user back to the login screen and disengages Catalyze
 @param sender id of the pressed button
 @return IBAction
 */
- (IBAction)logoutPressed:(id)sender
{
    [[CatalyzeUser currentUser] logoutWithSuccess:^(id result)
     {
         // dismiss modal stack
         UIViewController *vc = self.presentingViewController;
         while (vc.presentingViewController)
             vc = vc.presentingViewController;
         [vc dismissViewControllerAnimated:YES completion:NULL];
     }
                                          failure:^(NSDictionary *result, int status, NSError *error)
     {
         NSLog(@"Error while logging out");
         [PCADefinitions showAlert:LOGOUT_ERROR];
     }];
}

@end
