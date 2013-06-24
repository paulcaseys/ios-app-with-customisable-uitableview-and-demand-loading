//
//  ImagePickerViewController.h
//  iOSApp
//
//  Created by PAUL CASEY on 2013-06-24.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePickerViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    UIImagePickerController *imagePickerController;
    IBOutlet UIProgressView    *progressBar;
}

@property(nonatomic,retain)IBOutlet UIImageView *imageView;
@property(nonatomic,retain)IBOutlet UIBarButtonItem *saveImageBotton;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (readonly) IBOutlet UIProgressView    *progressBar;

-(IBAction)showCameraAction:(id)sender;

//-(IBAction)saveImageAction:(id)sender;

@end
