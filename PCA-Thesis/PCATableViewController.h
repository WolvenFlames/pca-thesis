//
//  PCATableViewController.h
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCADefinitions.h"
#import "Catalyze.h"
#import "PCASummaryViewController.h"
#import "PCAEditViewController.h"

@interface PCATableViewController : UITableViewController

// UI elements
@property (strong, nonatomic) IBOutlet UITableView *table;

@property NSMutableDictionary* symptoms;    // values for all symptoms
@property CatalyzeEntry* mostRecent;        // most recent survey submitted
@property NSInteger row;                    // row of current symptom
@property NSString *symptom;                // name of current symptom
@property double value;                     // value of current symptom

@end
