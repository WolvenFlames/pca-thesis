/*
 * Copyright (C) 2013 catalyze.io, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CatalyzeTest.h"
#import "Catalyze.h"

@interface CatalyzeTest()

@end

@implementation CatalyzeTest

//the following values are generated for test environments and inserted manually for now
static const NSString * const username = @"test@catalyze.io";
static const NSString * const password = @"password";
static const NSString * const apiKey = @"a866938e-1f72-4854-a481-54d8d40a7442";
static const NSString * const appId = @"861e031b-25b4-4e06-8a50-76e8a3d7528c";
const NSString * const secondaryUsername = @"test-secondary@catalyze.io";
const NSString * const secondaryPassword = @"password";
const NSString * const secondaryUsersId = @"9d2140fb-675a-4b01-b5ff-2eca06301cf9";

//class level
+ (void)setUp {
    [super setUp];
    
    __block BOOL finished = NO;
    
    [Catalyze setApiKey:apiKey.copy applicationId:appId.copy baseUrl:@"http://192.168.222.5:8443"];
    
    [CatalyzeUser logInWithUsernameInBackground:username.copy password:password.copy success:^(CatalyzeUser *result) {
        finished = YES;
    } failure:^(NSDictionary *result, int status, NSError *error) {
        NSLog(@"failed %@ %i %@", result, status, error);
        [NSException raise:@"AuthenticationException" format:@"Could not login"];
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
}

+ (void)tearDown {
    __block BOOL finished = NO;
    
    [[CatalyzeUser currentUser] logoutWithSuccess:^(id result) {
        finished = YES;
    } failure:^(NSDictionary *result, int status, NSError *error) {
        finished = YES;
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    [super tearDown];
}

@end
