//
//  PostViewController.m
//  iOSApp
//
//  Created by PAUL CASEY on 2013-06-23.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import "PostViewController.h"
#import "IIViewDeckController.h"

@interface PostViewController ()

@end

@implementation PostViewController
@synthesize _object;


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
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"drawer.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(drawerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 52, 44)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    // adds a title to the header
    self.title = @"post to webservice";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// EVENT HANDLERS


// side menu event handler
- (void)drawerButtonPressed {
    [self.viewDeckController toggleLeftViewAnimated:YES];
}





@end
