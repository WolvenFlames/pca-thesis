//
//  PCADefinitions.h
//  PCA-Thesis
//
//  Copyright (c) 2015 David Ganey and Jarrett Wilkes.
//  All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Catalyze.h"

#define STD_DEV_CUTOFF = 2

// custom UIColors for UI elements
#define MAYO_CLINIC_NAVY [UIColor colorWithRed:10.0/255.0 green:100.0/255.0 blue:170.0/255.0 alpha:1.0]
#define MAYO_CLINIC_NAVY2 [UIColor colorWithRed:0.0/255.0 green:85.0/255.0 blue:170.0/255.0 alpha:1.0]
#define TABLE_BLUE [UIColor colorWithRed:38.0/255.0 green:156.0/255.0 blue:254.0/255.0 alpha:0.5]
#define TABLE_GREEN [UIColor colorWithRed:31.0/255.0 green:223.0/255.0 blue:76.0/255.0 alpha:0.5]
#define TABLE_YELLOW [UIColor colorWithRed:255.0/255.0 green:201.0/255.0 blue:38.0/255.0 alpha:0.5]
#define TABLE_ORANGE [UIColor colorWithRed:255.0/255.0 green:109.0/255.0 blue:39.0/255.0 alpha:0.5]
#define TABLE_RED [UIColor colorWithRed:255.0/255.0 green:38.0/255.0 blue:37.0/255.0 alpha:0.5]

@interface PCADefinitions : NSObject

/**
Enumerated type for symptom names
*/
typedef enum
{
    PAIN = 0,
    ACTIVITY = 1,
    NAUSEA,
    DEPRESSION,
    ANXIETY,
    DROWSINESS,
    APPETITE,
    WEAKNESS,
    SHORTNESS_OF_BREATH,
    OTHER,
    MAX_SYMPTOMS = OTHER+1 //for for loops
} SYMPTOM;

/**
Enumerated type to distinguish between screens which use sliders and those which use segmented "radio" controls
*/
typedef enum
{
    SLIDER = 0,
    RADIO
} INPUT_TYPE;

/**
Enumerated type to distinguish types of errors.
Provides clarity in code by offloading UIAlertView functions and error message strings to PCADefinitions
*/
typedef enum
{
    INVALID_INPUT = 0,
    LOGIN_ERROR,
    SIGNUP_ERROR,
    PASSWORD_CHANGE_ERROR,
    USERNAME_TAKEN,
    NO_USER_LOGGED_IN,
    LOGOUT_ERROR,
    NOTHING_SELECTED,
    QUERY_EMPTY
} ERROR_TYPE;

/**
Enumerated type for popup selection buttons
*/
typedef enum
{
    CANCEL = 0,
    CONTINUE
} BUTTON_VALUE;

/**
Enumerated type for "doneness"
Users can complete entering symptoms in multiple ways, this distinguishes those routes
*/
typedef enum
{
    DONE_ENTERING = 0,
    NO_NEED,
    NOT_DONE,
    NOT_SET
} ALL_DONE_TYPE;

/**
Enumerated type for day of the week. There's probably an NS type for this...
*/
typedef enum
{
    SUNDAY = 1,
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY
} DAYS_OF_WEEK;

/**
 Enumerated type for HTTP status codes
 */
typedef enum
{
    BAD_REQUEST = 400,
    FORBIDDEN = 403,
    NOT_FOUND = 404,
    BAD_GATEWAY = 502
} HTTP_STATUS;

+(void) showAlert: (ERROR_TYPE) type;
+(void) showAlertWithText: (NSString*) text;
+(NSString*)determineSymptomName:(int)symptom;
+(CatalyzeEntry*) findMostRecent:(NSArray*) result;

@end
