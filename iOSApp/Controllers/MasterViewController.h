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

// google analytics
#import "GAITrackedViewController.h"
#import "GAI.h"

@class DetailViewController;
@class ProfileViewController;

// if not using google anayltics, then use UIViewController instead of GAITrackedViewController
@interface MasterViewController : GAITrackedViewController {
    
    NSURLConnection *theConnection;
    
    IBOutlet UITextView *texter;
	IBOutlet UITableView *tableView;
	IBOutlet UIImageView *imageView;
}

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) ProfileViewController *profileViewController;



@end
