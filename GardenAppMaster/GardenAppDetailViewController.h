//
//  GardenAppDetailViewController.h
//  GardenAppMaster
//
//  Created by PAUL CASEY on 2013-06-11.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GardenAppDetailViewController  : UIViewController {
    NSMutableDictionary *_object;    
}
@property (strong, nonatomic) NSMutableDictionary *_object;
@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
