//
//  GardenAppMasterViewController.m
//  GardenAppMaster
//
//  Created by PAUL CASEY on 2013-06-11.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import "GardenAppMasterViewController.h"

#import "GardenAppDetailViewController.h"

#import "SBJson.h"



@interface GardenAppMasterViewController () {
    //NSMutableArray *_objects;
}
@end

@implementation GardenAppMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    /*self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    */
    // PAULS CODE
    [self go];
    
}

#pragma mark Actions

- (void)go {
	
    
	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://api.instagram.com/v1/users/688542/media/recent?count=%22+me.imageCount+%22&access_token=688542.1fb234f.b393aba051d54bb9a03714ca63594171&callback=?"]];
    NSError *err;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&err];
    
    NSMutableArray *array = json[@"data"];
    
    NSLog(@"%@", [array objectAtIndex:0]);
    
    for (NSDictionary *item in array){
        NSString *created_time = [item valueForKey:@"created_time"];
        NSLog(@"created_time - %@",created_time);
        
        // You can also get nested properties like this
        //NSString *projectName = [item valueForKeyPath:@"project.name"];
    }
    
	texter.text = @"...";
}



@end
