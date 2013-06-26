//
//  MenuViewController.h
//  iOSApp
//
//  Created by PAUL CASEY on 2013-06-22.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileViewController;
@class MasterViewController;


@interface MenuViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *descriptionTexter;

- (IBAction)homeButtonTapHandler:(id)sender;
- (IBAction)profileButtonTapHandler:(id)sender;
- (IBAction)imagePickerButtonTapHandler:(id)sender;
- (IBAction)loginButtonTapHandler:(id)sender;

@property (strong, nonatomic) MasterViewController *masterViewController;
@property (strong, nonatomic) ProfileViewController *profileViewController;

@end
