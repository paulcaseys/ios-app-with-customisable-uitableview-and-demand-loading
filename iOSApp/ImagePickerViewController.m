//
//  ImagePickerViewController.m
//  iOSApp
//
//  Created by PAUL CASEY on 2013-06-24.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import "ImagePickerViewController.h"

#import "IIViewDeckController.h"
#import "Reachability.h"

#import <QuartzCore/QuartzCore.h>


@interface ImagePickerViewController ()

@end

@implementation ImagePickerViewController

@synthesize _object;
@synthesize imageView;
@synthesize saveImageBotton;
@synthesize imagePickerController;
@synthesize texterPageTitle;
@synthesize thumbnailImageView;


#pragma mark

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // menu button
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"drawer.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(drawerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 52, 44)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.title = @"photo";
    
    // adds the next button
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"submit" style:UIBarButtonItemStylePlain target:self action:@selector(initialiseCosmosSubmission)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    // adds texfield placeholder
    UIColor *color = [UIColor colorWithRed:191/255.0f green:191/255.0f blue:191/255.0f alpha:1.0f];
    [texterPageTitle setPlaceholder:@"Enter your caption for this photo"];
	[texterPageTitle setPlaceholderTextColor:color];
    
    //[thumbnailImageView setBackgroundColor:[UIColor blueColor]];
    
    // clears error text
    errorLabel.text = @"";
        
    [self openImagePicker];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    // Google analytics event tracking
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Image Picker Screen"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


-(void)openImagePicker {
    
    // Lazily allocate image picker controller
    if (!imagePickerController) {
        imagePickerController = [[UIImagePickerController alloc] init];
        
        // only provides the option to choose from library
        // may want to give the user the option to choose library or camera
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        // image picker needs a delegate so we can respond to its messages
        [imagePickerController setDelegate:self];
    }
    // Place image picker on the screen
    [self presentModalViewController:imagePickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    // remove overlay
    [self dismissModalViewControllerAnimated:YES];
    
    
    
    // checks for internet connection
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus == NotReachable) {
        //there-is-no-connection warning
        NSLog(@"Internet connection NOT available");
    } else {
        //my web-dependent code
        NSLog(@"Internet connection IS available");
        
        NSLog(@"POSTING DATA");
        
        // creates an async queue, so the page can be displayed before loading is complete
        dispatch_queue_t feedQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(feedQueue, ^{
            
            
            // Send post data
            
            CGSize  size  = {320*2, 480*2};
            UIImage *fullImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            UIImage *image = [self imageWithImage:fullImage scaledToSize:size];
            
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            
            NSString *filename = [NSString stringWithFormat:@"something.png"];
            
            // random number for cachebusting
            int randomNumber = arc4random() % 999999999;
            
            // need to parse the url because pipes in the url cause errors
            NSString *unDecodedURL =[NSString stringWithFormat:@"http://cosmos.is/api/service/upload_image/format/json/"];
            NSURL *decodedUrl = [NSURL URLWithString:[unDecodedURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
            
            
            // setting up the request object now
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:decodedUrl];
            [request setHTTPMethod:@"POST"];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            NSMutableData *body = [NSMutableData data];
            
            NSString *uniqueIdentifier = [self getUUID];
            
            // file
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; type=\"filedata\"; name=\"filedata\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            
            
            
            // caption
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_image_caption\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"iOS App photo"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            // image source
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_image_source\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",uniqueIdentifier] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            // external reference string
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"external_reference_string\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"autoincrement"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            // project name
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"project_name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"iOSAppProjectExample"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            // project password
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"project_password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"b816af010d9567864542020d6c7073ce"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            
            // cacheBuster
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"cacheBuster\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"1%d", randomNumber] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r \n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // setting the body of the post to the reqeust
            [request setHTTPBody:body];
            
            // now lets make the connection to the web
            
            
            NSURLResponse* response;
            NSError* error;
            NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSString *returnString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            NSLog(@"return: %@",returnString);
            
            NSDictionary* jsonResponse = [NSJSONSerialization
                                          JSONObjectWithData:result
                                          options:kNilOptions
                                          error:&error];
    
            
            

            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"loading complete!");
                NSString *uploaded_image_id = [jsonResponse valueForKey:@"uploaded_image_id"];
                [_object setValue:uploaded_image_id forKey:@"uploaded_image_id"];
                
                NSString *uploaded_image_caption = [jsonResponse valueForKey:@"uploaded_image_caption"];
                [_object setValue:uploaded_image_caption forKey:@"uploaded_image_caption"];
                
                NSString *uploaded_image_source = [jsonResponse valueForKey:@"uploaded_image_source"];
                [_object setValue:uploaded_image_source forKey:@"uploaded_image_source"];
                                
                NSString *uploaded_image_path_160 = [jsonResponse valueForKey:@"uploaded_image_path_160"];
                [_object setValue:uploaded_image_path_160 forKey:@"uploaded_image_path_160"];
                
                NSLog(@"%@", uploaded_image_source);
                NSLog(@"%@", uploaded_image_caption);
                NSLog(@"%@", uploaded_image_path_160);
                
                //NSURL *imageURL = [NSURL URLWithString:[_object valueForKey:@"uploaded_image_path_160"]];
                
                [self loadImageThumbnail:uploaded_image_path_160];
                
                /*
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                    NSData *data = [NSData dataWithContentsOfURL:imageURL];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        NSLog(@"imgloadded");
                        thumbnailImageView.image = image;
                    });
                });
                 */
                
            });
            
        });
                
    }    
    
}

- (void)loadImageThumbnail:(NSString *)uploaded_image_path_160 {
    //thumbnailImageView.image = [UIImage imageNamed:@"contact-me.jpg"];
    
    dispatch_queue_t queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue2, ^{
        NSLog(@"%@", uploaded_image_path_160);
        //NSURL *url = [NSURL URLWithString:uploaded_image_path_160];
        //NSData *data = [[NSData alloc]initWithContentsOfURL:url];
        /*UIImage *image = [[UIImage alloc]initWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                thumbnailImageView.image = image;
            });
        }*/
        /*NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_object valueForKey:@"uploaded_image_path_160"]]];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            thumbnailImageView.image = image;
            NSLog(@"imgloadded");
        });*/
    });
     
}


// example of entering data to cosmos
- (void)initialiseCosmosSubmission {
	
    // checks for internet connection
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus == NotReachable) {
        //there-is-no-connection warning
        NSLog(@"Internet connection NOT available");
        errorLabel.text = @"Internet connection unavailable";
        
    } else {
        //my web-dependent code
        NSLog(@"Internet connection IS available");
        
        
        // checks if the required fields are complete
        BOOL formErrors = [self validateForm];
        
        if (formErrors){
            //errorLabel.text = @"Please complete the form";
        } else {
            //errorLabel.text = @"Submitting form";
            
            // creates an async queue, so the page can be displayed before loading is complete
            dispatch_queue_t feedQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(feedQueue, ^{
                
                // define form values
                NSString *page_title = texterPageTitle.text;
                          
                                
                // random number for cachebusting
                int randomNumber = arc4random() % 999999999;
                
                
                // need to parse the url because pipes in the url cause errors
                NSString *unDecodedURL =[NSString stringWithFormat:@"http://cosmos.is/api/service/save/format/json/?detail_MessageId=&detail_ImageFile=&detail_ImageDescription=&detail_DateReceived=&detail_Name=&detail_FirstName=&detail_LastName=&detail_HomePhoneNumber=+&detail_EmailAddress=+&detail_Address=+&detail_Address2=&detail_Suburb=&detail_Postcode=+&detail_State=+&detail_Country=&detail_DateOfBirth=&detail_Gen1=true&detail_Gen2=false&detail_Gen3=&detail_Gen4=&detail_Gen5=&detail_Gen6=&detail_Gen7=&detail_Gen8=&detail_Gen9=&detail_Gen10=&classification_1=&classification_2=&classification_3=&classification_4=&classification_5=&page_title=%@&page_summary=&page_body_text=&page_image_url=&project_name=iOSAppProjectExample&project_password=b816af010d9567864542020d6c7073ce&external_reference_string=&cosmos_force=1&cacheBuster=%d", page_title, randomNumber];
                NSURL *decodedUrl = [NSURL URLWithString:[unDecodedURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
                NSData *url = [NSData dataWithContentsOfURL:decodedUrl];
                
                NSLog(@"url: %@", unDecodedURL);
                
                NSError *err;
                
                NSDictionary* jsonResponse = [NSJSONSerialization
                                              JSONObjectWithData:url
                                              options:kNilOptions
                                              error:&err];
                
                // all loaded
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    if (!jsonResponse) {
                        errorLabel.text = @"Unable to connect to server";
                        NSLog(@"NSError: %@", err);
                    } else {
                        errorLabel.text = @"Form submitted, thankyou";
                        NSString *refID = [jsonResponse valueForKey:@"unique_reference_id"];
                        NSLog(@"unique_reference_id: %@", refID);
                    }
                    
                });
                
            });
            
        }
        
    }    
    
}


// FORM VALIDATION
// returns over 0, if there is an error
- (BOOL)validateForm {
    
    // defines how many errors there are
    BOOL formErrors = NO;
    
    // removes all the invalid styles first
    
    //[self removeInvalidStyle:texterPageTitle];
    
    if([texterPageTitle.text isEqualToString:@""]){
        formErrors = YES;
        //[self addInvalidStyle:texterPageTitle];
    }
    return formErrors;
    
    
}
- (void)addInvalidStyle:(UITextField *)theTexter {
    theTexter.layer.cornerRadius = 8.0f;
    theTexter.layer.masksToBounds = YES;
    theTexter.layer.borderColor = [[UIColor redColor]CGColor];
    theTexter.layer.borderWidth = 1.0f;
}
- (void)removeInvalidStyle:(UITextField *)theTexter {
    theTexter.layer.borderWidth = 0.0f;
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (NSString *)getUUID {
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceUUID"];
    if (string == nil) {
        CFUUIDRef   uuid;
        CFStringRef uuidStr;
        
        uuid = CFUUIDCreate(NULL);
        uuidStr = CFUUIDCreateString(NULL, uuid);
        
        string = [NSString stringWithFormat:@"%@", uuidStr];
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"deviceUUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        CFRelease(uuidStr);
        CFRelease(uuid);
    }
    
    return string;
}


// EVENT HANDLERS
#pragma mark - Event handlers

// side menu event handler
- (void)drawerButtonPressed {
    [self.view endEditing:YES];
    [self.viewDeckController toggleLeftViewAnimated:YES];
}


-(IBAction)showCameraAction:(id)sender {
    [self openImagePicker];
    
}

@end