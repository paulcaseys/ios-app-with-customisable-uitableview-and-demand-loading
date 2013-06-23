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

@property (strong, nonatomic) ProfileViewController *profileViewController;
@property (strong, nonatomic) MasterViewController *masterViewController;

@end
