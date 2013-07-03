//
//  LoginEntryViewController.h
//  iOSApp
//
//  Created by PAUL CASEY on 2013-06-26.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import <UIKit/UIKit.h>

// google analytics
#import "GAITrackedViewController.h"
#import "GAI.h"


@interface LoginEntryViewController : GAITrackedViewController {
    NSMutableDictionary *_object;
    UIImagePickerController *imagePickerController;
    IBOutlet UILabel *errorLabel;
    IBOutlet UITextField *texterUsername;
    IBOutlet UITextField *texterPassword;
    IBOutlet UITextField *texterEmail;
}

@property (strong, nonatomic) NSMutableDictionary *_object;


@end
