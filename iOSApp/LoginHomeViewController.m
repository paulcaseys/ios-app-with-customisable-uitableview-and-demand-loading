//
//  LoginHomeViewController.m
//  iOSApp
//
//  Created by PAUL CASEY on 2013-06-26.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import "LoginHomeViewController.h"
#import "LoginNewAccountViewController.h"
#import "LoginEntryViewController.h"

#import "IIViewDeckController.h"
#import "Reachability.h"

@interface LoginHomeViewController ()

@end

@implementation LoginHomeViewController

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
    
    // menu button
    
    // adds the next button
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonItemStylePlain target:self action:@selector(closeModalButtonPressed)];
    self.navigationItem.leftBarButtonItem = anotherButton;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// EVENT HANDLERS
#pragma mark - Event handlers

// side menu event handler
- (void)closeModalButtonPressed {
    [self.view endEditing:YES];
    //[self.viewDeckController toggleLeftViewAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

// button event handler
- (IBAction)registerButtonPressed:(id)sender {
    if (!self.loginNewAccountViewController) {
        self.loginNewAccountViewController = [[LoginNewAccountViewController alloc] initWithNibName:@"LoginNewAccountViewController" bundle:nil];
    }
    // traverses arrays to find the object
    NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
    
    // custom back button text
    NSString *backButtonText = @"back";
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: backButtonText style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    self.loginNewAccountViewController._object = object;
    [self.navigationController pushViewController:self.loginNewAccountViewController animated:YES];
    
}

// button event handler
- (IBAction)loginButtonPressed:(id)sender {
    if (!self.loginEntryViewController) {
        self.loginEntryViewController = [[LoginEntryViewController alloc] initWithNibName:@"LoginEntryViewController" bundle:nil];
    }
    // traverses arrays to find the object
    NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
    
    // custom back button text
    NSString *backButtonText = @"back";
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: backButtonText style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    self.loginEntryViewController._object = object;
    [self.navigationController pushViewController:self.loginEntryViewController animated:YES];
}


@end
