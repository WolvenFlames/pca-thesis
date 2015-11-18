//
//  PCAProfileViewController.m
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import "PCAProfileViewController.h"

@interface PCAProfileViewController ()

@end

@implementation PCAProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // use zipcode to get city and state
    // REFERENCED FROM:
    // http://stackoverflow.com/questions/23387162/autofill-city-and-state-from-zip-code-in-ios
    NSString *zip = [[CatalyzeUser currentUser] extraForKey:@"zip"];
    if (zip != NULL)
    {
        CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
        [geoCoder geocodeAddressDictionary:@{(NSString*)kABPersonAddressZIPKey : zip}
                         completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if ([placemarks count] > 0)
             {
                 CLPlacemark* placemark = [placemarks objectAtIndex:0];
                 self.locationLabel.text = [NSString stringWithFormat:@"%@, %@ - %@", placemark.addressDictionary[(NSString*)kABPersonAddressCityKey], placemark.addressDictionary[(NSString*)kABPersonAddressStateKey], zip];
             }
             else       // no locations found, simply display zipcode
                 self.locationLabel.text = zip;
         }];
    }
    else        // no locations found, simply display zipcode
        self.locationLabel.text = zip;
    
    // get user's name and email
    NSString *name = [NSString stringWithFormat:@"%@ %@", [[CatalyzeUser currentUser] name].firstName, [[CatalyzeUser currentUser] name].lastName];
    NSString *email = [[CatalyzeUser currentUser] email].primary;
    if (name != NULL)
        self.nameLabel.text = name;
    else
        self.nameLabel.text = @"unknown user";
    if (email != NULL)
        self.emailLabel.text = email;
    else
        self.emailLabel.text = @"no email address";
    
    // error handling on phone number
    NSMutableString *phone = [[[CatalyzeUser currentUser] extraForKey:@"phone"] mutableCopy];
    if (phone != NULL)
    {
        // delete everything but numbers
        for (int i = 0; i < phone.length; i++)
        {
            if (!isdigit([phone characterAtIndex:i]))
            {
                [phone deleteCharactersInRange:NSMakeRange(i, 1)];
                i--;
            }
        }
        // add formatting
        [phone insertString:@"(" atIndex:0];
        [phone insertString:@") " atIndex:4];
        [phone insertString:@"-" atIndex:9];
        self.phoneLabel.text = [phone substringToIndex:14];
    }
    else
        self.phoneLabel.text = @"no phone number";
    
    // if applicable, get previous stored image path from NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *path = [defaults valueForKey:@"image"];
    NSLog(@"IMAGE PATH = %@", path);
    
    if (path == NULL)
    {
        // user has not previous set photo
        [self.photoDescription setHidden:NO];
        [self.photoButton setTitle:@"Add Photo" forState:UIControlStateNormal];
    }
    else
    {
        NSURL* url = [NSURL URLWithString:path];
        [self.photoDescription setHidden:YES];
        [self.photoButton setTitle:@"Change Photo" forState:UIControlStateNormal];
        
        // SOURCE: http://stackoverflow.com/questions/3837115/display-image-from-url-retrieved-from-alasset-in-iphone
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:url resultBlock:^(ALAsset *asset)
        {
            // retain size/origin values of UIImageView so the image can be scaled to them
            CGFloat xVal = self.imageView.frame.origin.x;
            CGFloat yVal = self.imageView.frame.origin.y;
            CGFloat hVal = self.imageView.frame.size.height;
            CGFloat wVal = self.imageView.frame.size.width;
            
            // get full-size image and scale it down
            UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            double hScale = image.size.height / hVal;
            double wScale = image.size.width / wVal;
            double scale;
            if (hScale > wScale)
                scale = hScale;
            else
                scale = wScale;
            
            if (hScale > 0 && wScale > 0)
            {
                // add image to view -- scaled to fit in UIImageView while still maintaining original proportions
                self.imageView.frame = CGRectMake(((wVal - (image.size.width / scale)) / 2) + xVal, ((hVal - (image.size.height / scale)) / 2) + yVal, (image.size.width / scale), (image.size.height / scale));
                self.imageView.image = image;
            }
            else
            {
                // error handling -- URL did not represent valid picture
                [self.photoDescription setHidden:NO];
                self.photoDescription.text = @"unable to load image";
                [self.photoButton setTitle:@"Add Photo" forState:UIControlStateNormal];
            }
        }
        failureBlock:^(NSError *error)
        {
            // error handling -- URL did not represent valud picture
            [self.photoDescription setHidden:NO];
            self.photoDescription.text = @"unable to load image";
            [self.photoButton setTitle:@"Add Photo" forState:UIControlStateNormal];
        }];
    }
    
    // format time interval string
    if (self.components != NULL)
    {
        // if all components are 0 (user took survey within a minute)
        if ([self.components year] == 0 && [self.components month] == 0 && [self.components day] == 0 && [self.components hour] == 0 && [self.components minute] == 0)
            self.timeLabel.text = @"less than a minute ago";
        else
        {
            NSString *years = @"", *months = @"", *days = @"", *hours = @"", *minutes = @"";
            if ([self.components year] > 0)
            {
                if ([self.components year] == 1)
                    years = [NSString stringWithFormat:@"%ld year, ", (long)[self.components year]];
                else
                    years = [NSString stringWithFormat:@"%ld years, ", (long)[self.components year]];
            }
            if ([self.components month] > 0)
            {
                if ([self.components month] == 1)
                    months = [NSString stringWithFormat:@"%ld month, ", (long)[self.components month]];
                else
                    months = [NSString stringWithFormat:@"%ld months, ", (long)[self.components month]];
            }
            if ([self.components day] > 0)
            {
                if ([self.components day] == 1)
                    days = [NSString stringWithFormat:@"%ld day, ", (long)[self.components day]];
                else
                    days = [NSString stringWithFormat:@"%ld days, ", (long)[self.components day]];
            }
            if ([self.components hour] > 0)
            {
                if ([self.components hour] == 1)
                    hours = [NSString stringWithFormat:@"%ld hour, ", (long)[self.components hour]];
                else
                    hours = [NSString stringWithFormat:@"%ld hours, ", (long)[self.components hour]];
            }
            if ([self.components minute] > 0)
            {
                if ([self.components minute] == 1)
                    minutes = [NSString stringWithFormat:@"%ld minute, ", (long)[self.components minute]];
                else
                    minutes = [NSString stringWithFormat:@"%ld minutes, ", (long)[self.components minute]];
            }
            // string formatted with year, month, day, hour, minute
            NSString *substr = [NSString stringWithFormat:@"%@%@%@%@%@", years, months, days, hours, minutes];
            substr = [substr substringToIndex:[substr length] - 2];     // remove extra ", "
            self.timeLabel.text = [NSString stringWithFormat:@"%@ ago", substr];
        }
    }
    else
        self.timeLabel.text = @"N/A";
    self.surveyLabel.text = [NSString stringWithFormat:@"Number of responses: %lu", (unsigned long)self.count];
    self.firstLabel.text = self.firstDate;
    
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Arial" size:20.0],NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = size;
    self.navigationController.navigationBar.barTintColor = MAYO_CLINIC_NAVY2;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.photoButton setTitleColor:MAYO_CLINIC_NAVY forState:UIControlStateNormal];
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.opaque = NO;
    
    UIImage *bgImage = [UIImage imageNamed: @"background-login.png"];       // load image
    self.backgroundImageView = [[UIImageView alloc] initWithImage:bgImage];     // initialize image view with image
    [self.backgroundImageView sizeToFit];                           // scale image to fit frame
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    CGRect frame = self.backgroundImageView.frame;
    float imgFactor = frame.size.height / frame.size.width;         // configure frame settings
    frame.size.width = [[UIScreen mainScreen] bounds].size.width;
    frame.size.height = frame.size.width * imgFactor;
    frame.origin.y = 23;
    self.backgroundImageView.frame = frame;
    [self.view addSubview:self.backgroundImageView];            // add image view as subview to main view
    [self.view sendSubviewToBack:self.backgroundImageView];     // send image to background so it doesn't cover objects
}

- (IBAction)changePhoto:(id)sender
{
    // SOURCE: http://www.appcoda.com/ios-programming-camera-iphone-app/
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // retain size/origin values of UIImageView so the image can be scaled to them
    CGFloat xVal = self.imageView.frame.origin.x;
    CGFloat yVal = self.imageView.frame.origin.y;
    CGFloat hVal = self.imageView.frame.size.height;
    CGFloat wVal = self.imageView.frame.size.width;
    
    // get dimensions of original image
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    double hScale = image.size.height / hVal;
    double wScale = image.size.width / wVal;
    double scale;
    if (hScale > wScale)
        scale = hScale;
    else
        scale = wScale;
    
    // add image to view -- scaled to fit in UIImageView while still maintaining original proportions
    self.imageView.frame = CGRectMake(((wVal - (image.size.width / scale)) / 2) + xVal, ((hVal - (image.size.height / scale)) / 2) + yVal, (image.size.width / scale), (image.size.height / scale));
    self.imageView.image = image;
    [self.photoDescription setHidden:YES];
    [self.photoButton setTitle:@"Change Photo" forState:UIControlStateNormal];
    
    // save image path to NSUserDefaults so image will persist
    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[path absoluteString] forKey:@"image"];     // overwrite stored user defaults
    [defaults synchronize];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
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

