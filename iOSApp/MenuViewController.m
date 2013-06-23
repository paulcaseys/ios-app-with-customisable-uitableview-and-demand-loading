//
//  MenuViewController.m
//  iOSApp
//
//  Created by PAUL CASEY on 2013-06-22.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import "MenuViewController.h"
#import "ProfileViewController.h"
#import "MasterViewController.h"
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
    self.descriptionTexter.text = @"hello";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// EVENT LISTENTERS

- (IBAction)homeButtonTapHandler:(id)sender {
    //[appDelegate testMethod];
    //AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    
    NSLog(@"gday");
    
    AppDelegate *objAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    ProfileViewController *s=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    [objAppDelegate.navigationController pushViewController:s animated:YES];
    
    //AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[del.navigationController pushViewController:self.profileViewController animated:YES];
    /*if (!appDelegate.centerViewController.profileViewController) {
        appDelegate.centerViewController.profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    }
     
    // traverses arrays to find the object
    //NSMutableDictionary *dictionary = [_dataArray objectAtIndex:indexPath.section];
    //NSArray *array = [dictionary objectForKey:@"data"];
    //NSMutableDictionary *object = array[indexPath.row];
    
    // custom back button text
    //NSString *backButtonText = @"back";
    //UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: backButtonText style: UIBarButtonItemStyleBordered target: nil action: nil];
    //[[self navigationItem] setBackBarButtonItem: newBackButton];
    
    //self.profileViewController.detailItem = object;
    //self.profileViewController._object = object;
    [self.navigationController pushViewController:self.profileViewController animated:YES];
    [theTableView deselectRowAtIndexPath:[theTableView indexPathForSelectedRow] animated:YES];
    */
}

@end
