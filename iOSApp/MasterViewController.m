//
//  MasterViewController.m
//  Master
//
//  Created by PAUL CASEY on 2013-06-11.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SimpleTableCell.h"
#import "ProfileViewController.h"

//#import "UITableViewCell+AutoDequeue.h"
#import "IIViewDeckController.h"

#include <stdlib.h>

BOOL animationRunning;
int section;


@interface MasterViewController () <UIGestureRecognizerDelegate, IIViewDeckControllerDelegate>{
    
    // define the dataArray
    NSMutableArray *_dataArray;
    
    // initialize the section arrays
    NSMutableArray *_firstItemsArray;
    NSMutableArray *_secondItemsArray;
    NSMutableArray *_thirdItemsArray;
    NSMutableArray *_fourthItemsArray;
    NSMutableArray *_fifthItemsArray;
    
    // initialize the section headings
    NSString *_firstItemsSectionHeading;
    NSString *_secondItemsSectionHeading;
    NSString *_thirdItemsSectionHeading;
    NSString *_fourthItemsSectionHeading;
    NSString *_fifthItemsSectionHeading;
    
}

@end

@implementation MasterViewController

// adds the title to the header
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master title", @"Master title");;
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated {
    // Google analytics event tracking
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Master Screen"];
}

// view is ready
- (void)viewDidLoad {
    
    [super viewDidLoad];   
    
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    
    
	// table style
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.rowHeight = 100;
	tableView.backgroundColor = [UIColor clearColor];
    
    // initialize the dataArray
    _dataArray = [[NSMutableArray alloc] init];
    
    // initialize the section arrays
    _firstItemsArray = [[NSMutableArray alloc] init];
    _secondItemsArray = [[NSMutableArray alloc] init];
    _thirdItemsArray = [[NSMutableArray alloc] init];
    _fourthItemsArray = [[NSMutableArray alloc] init];
    _fifthItemsArray = [[NSMutableArray alloc] init];
    
    // define the section headings
    _firstItemsSectionHeading = @"this is the first section heading";
    _secondItemsSectionHeading = @"this is the second section heading";
    _thirdItemsSectionHeading = @"this is the third section heading";
    _fourthItemsSectionHeading = @"this is the fourth section heading";
    _fifthItemsSectionHeading = @"this is the fifth section heading";
    
    // initialise load
    [self initialiseCosmosFeedLoad];
    
    // initialise animation
    animationRunning = YES;
    [self fadeOut:nil finished:nil context:nil];
    
    // menu button
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"drawer.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(drawerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 52, 44)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}



#pragma mark Actions

// example to parse cosmos
- (void)initialiseCosmosFeedLoad {
	
    // creates an async queue, so the page can be displayed before loading is complete
    dispatch_queue_t feedQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(feedQueue, ^{
        
        // random number for cachebusting
        int randomNumber = arc4random() % 999999999;
        
        // need to parse the url because pipes in the url cause errors
        NSString *unDecodedURL =[NSString stringWithFormat:@"http://cosmos.is/api/service/data/format/json/?project_name=SummerAtTarget&project_password=6CB4816A23A965B5DFD58E45F4C23&table=unique_references&batch=1&batchSize=6&whereConditionArray=project_id||9&select=*&orderBy=vote_count||desc&cacheBuster=%d", randomNumber];
        NSURL *decodedUrl = [NSURL URLWithString:[unDecodedURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        NSData *url = [NSData dataWithContentsOfURL:decodedUrl];
        
        NSLog(@"url: %@", unDecodedURL);
        
        NSError *err;
        
        NSDictionary* jsonResponse = [NSJSONSerialization
                               JSONObjectWithData:url
                               options:kNilOptions
                               error:&err];
        
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"loading complete!");
            
            
            if (!jsonResponse) {
                NSLog(@"NSError: %@", err);
            } else {
                
                // FIRST GROUP OF ITEMS
                for (NSMutableDictionary *itemFromGroup1 in jsonResponse){
                    // you could set up a condition here to detect which category it is in, then define which array to place it in
                    [self parseAndPushCosmosItemIntoArray:itemFromGroup1 theArray:_firstItemsArray];
                }
                // SECOND GROUP OF ITEMS (this could be from a different feed)
                for (NSMutableDictionary *itemFromGroup2 in jsonResponse){
                    // you could set up a condition here to detect which category it is in, then define which array to place it in
                    [self parseAndPushCosmosItemIntoArray:itemFromGroup2 theArray:_secondItemsArray];
                }
                // now put them into the _dataArray
                [_dataArray addObject:[NSDictionary dictionaryWithObject:_firstItemsArray forKey:@"data"]];
                [_dataArray addObject:[NSDictionary dictionaryWithObject:_secondItemsArray forKey:@"data"]];
                
                // reload table
                [tableView reloadData];
            }
        });
        
    });
    
}



// this is where you can parse out certain objects and
- (void)parseAndPushCosmosItemIntoArray:(NSMutableDictionary *)theDictionary theArray:(NSMutableArray *)theArray {
    
    // create an obj to insert into the table
    NSMutableDictionary *obj = [NSMutableDictionary dictionary];
    
    // parses object
    NSString *page_title = [theDictionary valueForKey:@"page_title"];
    [obj setValue:page_title forKey:@"page_title"];
    
    // parses object
    NSString *unique_reference_id = [theDictionary valueForKey:@"unique_reference_id"];
    [obj setValue:unique_reference_id forKey:@"unique_reference_id"];
    
    // parses nested object
    NSArray *uploaded_images = [theDictionary valueForKey:@"uploaded_images"];
    NSString *img75 = @"";
    for (NSDictionary *uploaded_image in uploaded_images){
        img75 = [uploaded_image valueForKey:@"uploaded_image_path_75"];
    }
    [obj setValue:img75 forKey:@"img75"];
    
    // checks if the array exists
    if (!theArray) {
        theArray = [[NSMutableArray alloc] init];
    }
    
    // inserting to table array
    [theArray insertObject:obj atIndex:0];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

// defines the number of sections in table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dataArray count];
}

// defines the title of each section (array)
- (NSString *)tableView:(UITableView *)theTableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return _firstItemsSectionHeading;
    } else if(section == 1) {
        return _secondItemsSectionHeading;
    } else if(section == 2) {
        return _thirdItemsSectionHeading;
    } else if(section == 3) {
        return _fourthItemsSectionHeading;
    } else {
        return _fifthItemsSectionHeading;
    }
}

// defines how many rows in each section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows it should expect should be based on the section
    NSDictionary *dictionary = [_dataArray objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"data"];
    return [array count];
    //return _objects.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        // traverses arrays to find the object
        NSMutableDictionary *dictionary = [_dataArray objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"data"];
        NSMutableDictionary *object = array[indexPath.row];
        
        cell.nameLabel.text = [object valueForKey:@"page_title"];
        
        
        // image scales to correct aspect ratio
        cell.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        // image loading with async and cache
        NSURL *imageURL = [NSURL URLWithString:[object valueForKey:@"img75"]];
        NSString *key = [[object valueForKey:@"img75"] MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            cell.thumbnailImageView.image = image;
        } else {
            cell.thumbnailImageView.image = [UIImage imageNamed:@"loading-thumb.png"];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^{
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                [FTWCache setObject:data forKey:key];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    cell.thumbnailImageView.image = image;
                });
            });
        }
        
    }
    return cell;
}


/// TAPS TO SECONDARY LEVEL
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.detailViewController) {
        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    }
    // traverses arrays to find the object
    NSMutableDictionary *dictionary = [_dataArray objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    NSMutableDictionary *object = array[indexPath.row];
    
    // custom back button text
    NSString *backButtonText = @"back";
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: backButtonText style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    self.detailViewController.detailItem = object;
    self.detailViewController._object = object;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
    [theTableView deselectRowAtIndexPath:[theTableView indexPathForSelectedRow] animated:YES];
}




// EXAMPLE ANIMATION

- (void) fadeOut:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2];
    [UIView  setAnimationDelegate:self];
    if(animationRunning){
        [UIView setAnimationDidStopSelector:@selector(fadeIn:finished:context:) ];
    }
    [texter setAlpha:0.00];
    [UIView commitAnimations];
}

- (void) fadeIn:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2];
    [UIView  setAnimationDelegate:self];
    if(animationRunning){
        [UIView setAnimationDidStopSelector:@selector(fadeOut:finished:context:) ];
    }
    [texter setAlpha:1.00];
    [UIView commitAnimations];
}




// EVENT HANDLERS

// side menu event handler
- (void)drawerButtonPressed {
    [self.viewDeckController toggleLeftViewAnimated:YES];
}




@end
