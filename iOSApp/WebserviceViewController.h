//
//  WebserviceViewController.h
//  iOSApp
//
//  Created by PAUL CASEY on 2013-06-23.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//


#import <UIKit/UIKit.h>

// google analytics
#import "GAITrackedViewController.h"
#import "GAI.h"
#import "UIPlaceHolderTextView.h"

@interface WebserviceViewController  : GAITrackedViewController <UITextFieldDelegate> {
    NSMutableDictionary *_object;
    IBOutlet UITextField *texterFirstName;
    IBOutlet UITextField *texterLastName;
    IBOutlet UILabel *errorLabel;
    //IBOutlet UIPlaceHolderTextView *texterFirstName;
    //IBOutlet UIPlaceHolderTextView *texterLastName;
}
- (IBAction)submitFormButtonTapHandler:(id)sender;

@property (strong, nonatomic) NSMutableDictionary *_object;



@end
