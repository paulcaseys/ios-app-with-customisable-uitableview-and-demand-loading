//
//  GardenAppDetailViewController.m
//  GardenAppMaster
//
//  Created by PAUL CASEY on 2013-06-11.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import "GardenAppDetailViewController.h"

@interface GardenAppDetailViewController ()
- (void)configureView;
@end

@implementation GardenAppDetailViewController
@synthesize _object;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
        
    
    [self configureView];
}

- (void)configureView {
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
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
							
@end
