iOS App Boilerplate for quick setup
================
This boilerplate helps build fast, robust, and adaptable iPhone Apps.

It saves time by including common libraries and analytics. So the basics are already covered.


***
parsing the json
-------------

#### using instagram feed

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

        }

        texter.text = @"...";
    }

#### using cosmos feed

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
            NSString *unique_reference_id = [item valueForKey:@"unique_reference_id"];

            // You can also get nested images like this
            NSArray *uploaded_images = [item valueForKey:@"uploaded_images"];
            for (NSDictionary *uploaded_image in uploaded_images){
                NSString *img75 = [uploaded_image valueForKey:@"uploaded_image_path_75"];
                NSLog(@"img75: %@",img75);
            }
            [self insertNewItemFromFeed:unique_reference_id];
        }
        texter.text = @"...";

    }

you can check if the respons is an array or a object (cosmos is an array, instagram is an object)

    if ([json isKindOfClass: [NSArray class]])
        NSLog(@"yes we got an Array");
    else if ([json isKindOfClass: [NSDictionary class]])
        NSLog(@"yes we got an dictionary");
    else
        NSLog(@"neither array nor dictionary!");


***
adding an image to tableview
---------
#### basic way
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

        //NSData *imageData= [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:news.image_small]];
        //cell.imageView.image=[UIImage imageWithData:imageData];
        //cell.imageView.image = [object description];
        cell.imageView.image = [UIImage imageNamed:@"contact-me.jpg"];
        return cell;
    }


#### custom layout
with async image loading and image caching


    - (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {


        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];

            NSMutableDictionary *object = _objects[indexPath.row];

            cell.nameLabel.text = [object valueForKey:@"page_title"];

            NSURL *imageURL = [NSURL URLWithString:[object valueForKey:@"img75"]];
            NSString *key = [[object valueForKey:@"img75"] MD5Hash];
            NSData *data = [FTWCache objectForKey:key];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                cell.thumbnailImageView.image = image;
            } else {
                cell.thumbnailImageView.image = [UIImage imageNamed:@"img_def"];
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
    }



***
Good introduction to creating custom table cells
------------------
http://www.appcoda.com/customize-table-view-cells-for-uitableview/



***
Altering the backbutton (in the parent .m file)
/// TAPS TO SECONDARY LEVEL
    - (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        if (!self.detailViewController) {
            self.detailViewController = [[GardenAppDetailViewController alloc] initWithNibName:@"GardenAppDetailViewController" bundle:nil];
        }
        // traverses arrays to find the object
        NSMutableDictionary *dictionary = [_dataArray objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"data"];
        NSMutableDictionary *object = array[indexPath.row];

        // custom back button text
        NSString *backButtonText = @"back";
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: backButtonText style: UIBarButtonItemStyleBordered target: nil action: nil];
        [[self navigationItem] setBackBarButtonItem: newBackButton];

        //self.detailViewController.detailItem.description = @"hi";
        self.detailViewController.detailItem = object;
        self.detailViewController._object = object;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
        [theTableView deselectRowAtIndexPath:[theTableView indexPathForSelectedRow] animated:YES];
    }


***
Google Analytics
----

#### before you begin

you will need
A new Google Analytics app property and profile.
https://support.google.com/analytics/answer/2614741?hl=en

#### 1. change the GUID
in the AppDelegate.m file, change the following line to use your own GUID

    [[GAI sharedInstance] trackerWithTrackingId:@"UA-41820379-2"];


#### 2. add tracking to your views

add this to every .h view you want to track events in

    // google analytics
    #import "GAITrackedViewController.h"
    #import "GAI.h"

and change the interface in .h

    @interface MasterViewController : GAITrackedViewController


In the .m file of any view you want to track, add this to your `viewDidAppear` method. This tracking method is similar to "event tracking" it can be called anywhere


    - (void)viewDidAppear:(BOOL)animated {
        // Google analytics event tracking
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker sendView:@"Master Screen"];
    }

#### 3. verifying that it works

you should see some google logs in your console, but you can also check analytics

now go to analytics.google.com and you can view the

choose '[your project]' from '[your name]'

then go to
reporting > realtime > Screens
then the tab which says 'Screen Views (last 30 mins)'

it should display the screen views!



***
Recommended, but not required
------------------
use cocoapods for organising your frameworks
http://cocoapods.org/