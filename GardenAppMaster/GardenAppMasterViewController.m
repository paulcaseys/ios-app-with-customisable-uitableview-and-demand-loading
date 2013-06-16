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


@interface GardenAppMasterViewController () {
    NSMutableArray *_objects;
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
    
    // initialise load
    [self initialiseCosmosFeedLoad];
    
    // initialise animation
    //animationRunning = YES;
    //[self fadeOut:nil finished:nil context:nil];
    
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
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:url
                          options:kNilOptions
                          error:&err];
    
    for (NSDictionary *item in json){
        // create an obj to insert into the table
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        
        NSString *page_title = [item valueForKey:@"page_title"];
        [dictionary setValue:page_title forKey:@"page_title"];
        
        NSString *unique_reference_id = [item valueForKey:@"unique_reference_id"];
        [dictionary setValue:unique_reference_id forKey:@"unique_reference_id"];
        
        // You can also get nested images like this
        NSArray *uploaded_images = [item valueForKey:@"uploaded_images"];
        NSString *img75 = @"";
        for (NSDictionary *uploaded_image in uploaded_images){            
            img75 = [uploaded_image valueForKey:@"uploaded_image_path_75"];
            //NSLog(@"img75: %@",img75);
        }
        
        [dictionary setValue:img75 forKey:@"img75"];
        
        [self insertNewItemFromFeed:dictionary];
        [self insertNewItemFromFeed:dictionary];
        [self insertNewItemFromFeed:dictionary];
        [self insertNewItemFromFeed:dictionary];
    }
	texter.text = @"...";
}

// example to parse instagram
- (void)initialiseInstagramFeedLoad {    
    
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
        NSString *imgLow = [item valueForKeyPath:@"images.low_resolution.url"];
        NSLog(@"imgLow - %@",imgLow);
        //[self insertNewItemFromFeed:imgLow];

    }
    
	texter.text = @"...";
}

- (void)insertNewItemFromFeed:(NSMutableDictionary *)obj
{
    //if (string == nil) string = @"Default Value";
    
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:obj atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    NSString *str = @"whatevs";
    [_objects insertObject:str atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSMutableDictionary *object = _objects[indexPath.row];
        cell.textLabel.text = [object valueForKey:@"page_title"];
        
        NSData *imageData= [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[object valueForKey:@"img75"]]];
        cell.contentMode = UIViewContentModeScaleAspectFit;
        cell.image=[UIImage imageWithData:imageData];
        //cell.image = [UIImage imageNamed:@"contact-me.jpg"];
    }
    
    
    
    
    /*
     // RUNS SLOW
    //static NSString *CellIdentifier = @"Cell";
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        NSMutableDictionary *object = _objects[indexPath.row];
        
        cell.nameLabel.text = [object valueForKey:@"page_title"];
        
        NSData *imageData= [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[object valueForKey:@"img75"]]];
        cell.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
        //cell.thumbnailImageView.image=[UIImage imageWithData:imageData];
        cell.thumbnailImageView.image = [UIImage imageNamed:@"contact-me.jpg"];
        
    }
    
    
    // example image from the library
    //cell.thumbnailImageView.image = [UIImage imageNamed:@"contact-me.jpg"];
     */
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[GardenAppDetailViewController alloc] initWithNibName:@"GardenAppDetailViewController" bundle:nil];
    }
    NSDate *object = _objects[indexPath.row];
    self.detailViewController.detailItem = object;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
