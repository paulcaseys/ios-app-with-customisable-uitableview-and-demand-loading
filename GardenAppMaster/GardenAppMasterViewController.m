//
//  GardenAppMasterViewController.m
//  GardenAppMaster
//
//  Created by PAUL CASEY on 2013-06-11.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import "GardenAppMasterViewController.h"

#import "GardenAppDetailViewController.h"

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
    [self initialiseFeedLoad];
    
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

- (void)initialiseFeedLoad {
	
    
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
        [self insertNewItemFromFeed:imgLow];

    }
    
	texter.text = @"...";
}

- (void)insertNewItemFromFeed:(NSString *)string
{
    if (string == nil) string = @"Default Value";
    
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    NSString *str = string;
    [_objects insertObject:str atIndex:0];
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
    }
    
    
    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
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

@end
