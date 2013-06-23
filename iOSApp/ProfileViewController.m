//
//  DetailViewController.m
//  iOSApp
//
//  Created by PAUL CASEY on 2013-06-18.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import "ProfileViewController.h"
#import "IIViewDeckController.h"

@interface ProfileViewController ()
- (void)configureView;
@end

@implementation ProfileViewController
@synthesize _object;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    // Google analytics event tracking
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Detail Screen"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // menu button
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"drawer.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(drawerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 52, 44)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self configureView];
}

- (void)configureView {
    // Update the user interface for the detail item.
    
    self.title = @"profile";
    
    if (_object) {
        //NSLog(@"_object: %@", _object);
        
        // adds title to header
        self.title = [_object valueForKey:@"page_title"];
        
        // adds description to page
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    //NSLog(@"test: %@", [_object valueForKey:@"page_title"]);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}



// EVENT HANDLERS


// side menu event handler
- (void)drawerButtonPressed {
    [self.viewDeckController toggleLeftViewAnimated:YES];
}



@end

