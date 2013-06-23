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
#import "PostViewController.h"

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
- (IBAction)postButtonTapHandler:(id)sender {
    
    // defines the app delegate
    AppDelegate *objAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // defines the next view and hides the backbutton
    PostViewController *newView = [[PostViewController alloc] initWithNibName:@"PostViewController" bundle:nil];
    newView.navigationItem.hidesBackButton = YES;
    
    // pushes the next view onto stage
    [objAppDelegate.navigationController pushViewController:newView animated:NO];
    
    // close the left panel
    [self.viewDeckController closeLeftView];
    
}




@end
