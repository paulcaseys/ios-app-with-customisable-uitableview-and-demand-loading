//
//  GardenAppMasterViewController.h
//  GardenAppMaster
//
//  Created by PAUL CASEY on 2013-06-11.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class GardenAppDetailViewController;


@interface GardenAppMasterViewController : UITableViewController {
    
    IBOutlet UITextView *texter;
    
    NSURLConnection *theConnection;
}

@property (strong, nonatomic) GardenAppDetailViewController *detailViewController;

@end
