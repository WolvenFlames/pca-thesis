//
//  PCAHistoryTableViewController.h
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCADefinitions.h"
#import "Catalyze.h"
#import "PCAHistoryViewController.h"

@interface PCAHistoryTableViewController : UITableViewController

@property NSArray* surveys;                 // array of all submitted surveys
@property CatalyzeEntry* currentEntry;      // survey we're currently viewing
@property NSArray* tableData;               // list of symptom names
@property NSArray* data;                    // list of values user entered

@end
