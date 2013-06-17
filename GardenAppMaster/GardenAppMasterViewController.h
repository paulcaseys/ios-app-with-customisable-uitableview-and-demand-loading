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


@interface GardenAppMasterViewController : UIViewController {
    
    NSURLConnection *theConnection;
    
    IBOutlet UITextView *texter;
	IBOutlet UITableView *tableView;
	IBOutlet UIImageView *imageView;
}

@property (strong, nonatomic) GardenAppDetailViewController *detailViewController;


@end
