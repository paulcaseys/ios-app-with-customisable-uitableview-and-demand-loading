//
//  MenuViewController.m
//  iOSApp
//
//  Created by PAUL CASEY on 2013-06-22.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import "MenuViewController.h"
#import "MasterViewController.h"
#import "ProfileViewController.h"
#import "WebserviceViewController.h"
#import "ImagePickerViewController.h"
#import "LoginHomeViewController.h"

#import "IIViewDeckController.h"
#import "AppDelegate.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.descriptionTexter.text = @"hello";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// EVENT LISTENTERS

// button handler
- (IBAction)homeButtonTapHandler:(id)sender {
    
    // defines the app delegate
    AppDelegate *objAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // defines the next view and hides the backbutton
    MasterViewController *newView = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    newView.navigationItem.hidesBackButton = YES;
    
    // pushes the next view onto stage
    [objAppDelegate.navigationController pushViewController:newView animated:NO];
    
    // close the left panel
    [self.viewDeckController closeLeftView];

}

// button handler
- (IBAction)profileButtonTapHandler:(id)sender {
    
    // defines the app delegate
    AppDelegate *objAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // defines the next view and hides the backbutton
    ProfileViewController *newView = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    newView.navigationItem.hidesBackButton = YES;
    
    // pushes the next view onto stage
    [objAppDelegate.navigationController pushViewController:newView animated:NO];
    
    // close the left panel
    [self.viewDeckController closeLeftView];
    
}

// button handler
- (IBAction)webserviceButtonTapHandler:(id)sender {
    
    // defines the app delegate
    AppDelegate *objAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // defines the next view and hides the backbutton
    WebserviceViewController *newView = [[WebserviceViewController alloc] initWithNibName:@"WebserviceViewController" bundle:nil];
    newView.navigationItem.hidesBackButton = YES;
    
    // pushes the next view onto stage
    [objAppDelegate.navigationController pushViewController:newView animated:NO];
    
    // close the left panel
    [self.viewDeckController closeLeftView];
    
}


// button handler
- (IBAction)imagePickerButtonTapHandler:(id)sender {
    
    // defines the app delegate
    AppDelegate *objAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // defines the next view and hides the backbutton
    ImagePickerViewController *newView = [[ImagePickerViewController alloc] initWithNibName:@"ImagePickerViewController" bundle:nil];
    newView.navigationItem.hidesBackButton = YES;
    
    // pushes the next view onto stage
    [objAppDelegate.navigationController pushViewController:newView animated:NO];
    
    // close the left panel
    [self.viewDeckController closeLeftView];
    
}


// button handler
- (IBAction)loginButtonTapHandler:(id)sender {
    
    // defines the app delegate
    AppDelegate *objAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4];
    // here I put the code to set the posting button off the top of the view
    [UIView commitAnimations];
    
    // defines the next view and hides the backbutton
    LoginHomeViewController *newView = [[LoginHomeViewController alloc] initWithNibName:@"LoginHomeViewController" bundle:nil];
    newView.navigationItem.hidesBackButton = YES;
    
    UINavigationController *newNavController = [[UINavigationController alloc] initWithRootViewController:newView];
    
    // pushes the next view onto stage
    [objAppDelegate.navigationController presentModalViewController:newNavController animated:YES];
    
    // close the left panel
    [self.viewDeckController closeLeftView];
    
}




@end
