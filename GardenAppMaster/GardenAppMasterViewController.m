//
//  GardenAppMasterViewController.m
//  GardenAppMaster
//
//  Created by PAUL CASEY on 2013-06-11.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import "GardenAppMasterViewController.h"
#import "GardenAppDetailViewController.h"
#import "SimpleTableCell.h"


BOOL animationRunning;
int section;


@interface GardenAppMasterViewController () {
    NSMutableArray *_objects;
    NSMutableArray *_dataArray;
    
    NSMutableArray *_temporaryItemsArray;
    
    NSString *_firstItemsSectionHeading;
    NSMutableArray *_firstItemsArray;
    
    NSString *_secondItemsSectionHeading;
    NSMutableArray *_secondItemsArray;
    
    NSString *_thirdItemsSectionHeading;
    NSMutableArray *_thirdItemsArray;
    
    NSString *_fourthItemsSectionHeading;
    NSMutableArray *_fourthItemsArray;
    
    NSString *_fifthItemsSectionHeading;
    NSMutableArray *_fifthItemsArray;
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
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    
	//
	// Change the properties of the imageView and tableView (these could be set
	// in interface builder instead).
	//
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.rowHeight = 100;
	tableView.backgroundColor = [UIColor clearColor];
    
            
    //Initialize the dataArray
    _dataArray = [[NSMutableArray alloc] init];
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
    
}


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

#pragma mark Actions

// example to parse cosmos
- (void)initialiseCosmosFeedLoad {
	
    // need to parse the url because pipes in the url cause errors
    NSString *unDecodedURL =[NSString stringWithFormat:@"http://cosmos.is/api/service/data/format/json/?project_name=SummerAtTarget&project_password=6CB4816A23A965B5DFD58E45F4C23&table=unique_references&batch=1&batchSize=6&whereConditionArray=project_id||9&select=*&orderBy=vote_count||desc"];
    NSURL *decodedUrl = [NSURL URLWithString:[unDecodedURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    NSData *url = [NSData dataWithContentsOfURL:decodedUrl];
    
    NSError *err;
    NSDictionary* json1 = [NSJSONSerialization
                          JSONObjectWithData:url
                          options:kNilOptions
                          error:&err];
    
    // FIRST GROUP OF ITEMS    
    for (NSMutableDictionary *itemFromGroup1 in json1){
        // you could set up a condition here to detect which category it is in, then define which array to place it in        
        [self parseAndPushItemIntoArray:itemFromGroup1 theArray:_firstItemsArray];
    }
    // SECOND GROUP OF ITEMS
    for (NSMutableDictionary *itemFromGroup2 in json1){
        // you could set up a condition here to detect which category it is in, then define which array to place it in
        [self parseAndPushItemIntoArray:itemFromGroup2 theArray:_secondItemsArray];
    }
    // now put them into the _dataArray
    [_dataArray addObject:[NSDictionary dictionaryWithObject:_firstItemsArray forKey:@"data"]];
    [_dataArray addObject:[NSDictionary dictionaryWithObject:_secondItemsArray forKey:@"data"]];
    
    
	texter.text = @"...";
}



- (void)parseAndPushItemIntoArray:(NSMutableDictionary *)theDictionary theArray:(NSMutableArray *)theArray
{
    
    // create an obj to insert into the table
    NSMutableDictionary *obj = [NSMutableDictionary dictionary];
    /*
    NSString *sectionID = [dictionary valueForKey:@"sectionID"];
    [obj setValue:sectionID forKey:@"sectionID"];
     */
    
    NSString *page_title = [theDictionary valueForKey:@"page_title"];
    [obj setValue:page_title forKey:@"page_title"];
    
    NSString *unique_reference_id = [theDictionary valueForKey:@"unique_reference_id"];
    [obj setValue:unique_reference_id forKey:@"unique_reference_id"];
    
    // You can also get nested images like this
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
    
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dataArray count];
}

- (NSString *)tableView:(UITableView *)theTableView titleForHeaderInSection:(NSInteger)section
{
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows it should expect should be based on the section
    NSDictionary *dictionary = [_dataArray objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"data"];
    return [array count];
    //return _objects.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
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
        
        NSURL *imageURL = [NSURL URLWithString:[object valueForKey:@"img75"]];
        NSString *key = [[object valueForKey:@"img75"] MD5Hash];
        NSData *data = [FTWCache objectForKey:key];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            cell.thumbnailImageView.image = image;
        } else {
            imageView.image = [UIImage imageNamed:@"img_def"];
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
         /**/
        
    }
    
    /*
     // BASIC table cell
     static NSString *CellIdentifier = @"Cell";
     
     UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     
     NSMutableDictionary *object = _objects[indexPath.row];
     cell.textLabel.text = [object valueForKey:@"page_title"];
     
     NSData *imageData= [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[object valueForKey:@"img75"]]];
     cell.contentMode = UIViewContentModeScaleAspectFit;
     cell.imageView.image=[UIImage imageWithData:imageData];
     //cell.image = [UIImage imageNamed:@"contact-me.jpg"];
     }
     */
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)theTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [theTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[GardenAppDetailViewController alloc] initWithNibName:@"GardenAppDetailViewController" bundle:nil];
    }
    // traverses arrays to find the object
    NSMutableDictionary *dictionary = [_dataArray objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    NSMutableDictionary *object = array[indexPath.row];
    
    self.detailViewController.detailItem = object;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
    [theTableView deselectRowAtIndexPath:[theTableView indexPathForSelectedRow] animated:YES];
}


@end
