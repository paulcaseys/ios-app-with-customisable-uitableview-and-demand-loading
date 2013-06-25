//
//  ImagePickerViewController.h
//  iOSApp
//
//  Created by PAUL CASEY on 2013-06-24.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import <UIKit/UIKit.h>

// google analytics
#import "GAITrackedViewController.h"
#import "GAI.h"

#import "UIPlaceHolderTextView.h"



@interface ImagePickerViewController : GAITrackedViewController<UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    NSMutableDictionary *_object;
    UIImagePickerController *imagePickerController;
    IBOutlet UILabel *errorLabel;
    IBOutlet UIPlaceHolderTextView *texterPageTitle;
    
}

@property (strong, nonatomic) NSMutableDictionary *_object;
@property(nonatomic,retain)IBOutlet UIImageView *imageView;
@property(nonatomic,retain)IBOutlet UIBarButtonItem *saveImageBotton;
@property(nonatomic,retain)IBOutlet UIPlaceHolderTextView *texterPageTitle;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;

-(IBAction)showCameraAction:(id)sender;

//-(IBAction)saveImageAction:(id)sender;

@end
