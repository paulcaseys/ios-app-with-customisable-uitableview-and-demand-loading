//
//  LoginHomeViewController.h
//  iOSApp
//
//  Created by PAUL CASEY on 2013-06-26.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import <UIKit/UIKit.h>

// google analytics
#import "GAITrackedViewController.h"
#import "GAI.h"

@class LoginNewAccountViewController;
@class LoginEntryViewController;

@interface LoginHomeViewController : GAITrackedViewController {
    
}

@property (strong, nonatomic) LoginNewAccountViewController *loginNewAccountViewController;
@property (strong, nonatomic) LoginEntryViewController *loginEntryViewController;

- (IBAction)registerButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;

@end
