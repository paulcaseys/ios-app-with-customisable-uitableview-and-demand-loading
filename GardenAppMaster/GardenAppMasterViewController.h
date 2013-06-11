//
//  GardenAppMasterViewController.h
//  GardenAppMaster
//
//  Created by PAUL CASEY on 2013-06-11.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GardenAppDetailViewController;
@class SBJsonStreamParser;
@class SBJsonStreamParserAdapter;



@interface GardenAppMasterViewController : UITableViewController {
    
    IBOutlet UITextView *texter;
    
    NSURLConnection *theConnection;
    SBJsonStreamParser *parser;
    SBJsonStreamParserAdapter *adapter;
}

//- (void)go;

//@property (strong, nonatomic) GardenAppDetailViewController *detailViewController;

@end
