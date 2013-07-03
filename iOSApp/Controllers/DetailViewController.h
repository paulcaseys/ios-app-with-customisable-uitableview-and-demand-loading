//
//  DetailViewController.h
//  iOSApp
//
//  Created by PAUL CASEY on 2013-06-18.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import <UIKit/UIKit.h>

// google analytics
#import "GAITrackedViewController.h"
#import "GAI.h"

@interface DetailViewController  : GAITrackedViewController {
    NSMutableDictionary *_object;
}
@property (strong, nonatomic) NSMutableDictionary *_object;
@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
