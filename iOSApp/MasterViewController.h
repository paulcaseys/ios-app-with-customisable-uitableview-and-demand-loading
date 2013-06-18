//
//  MasterViewController.h
//  iOSApp
//
//  Created by PAUL CASEY on 2013-06-18.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FTWCache.h"
#import "NSString+MD5.h"

@class DetailViewController;


@interface MasterViewController : UIViewController {
    
    NSURLConnection *theConnection;
    
    IBOutlet UITextView *texter;
	IBOutlet UITableView *tableView;
	IBOutlet UIImageView *imageView;
}

@property (strong, nonatomic) DetailViewController *detailViewController;



@end
