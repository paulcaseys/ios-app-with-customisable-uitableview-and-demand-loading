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

@interface ImagePickerViewController ()

@end

@implementation ImagePickerViewController

@synthesize imageView;
@synthesize saveImageBotton;
@synthesize imagePickerController;
@synthesize progressBar;

#pragma mark

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // menu button
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"drawer.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(drawerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 52, 44)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.title = @"photo";
    
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

// EVENT HANDLERS


// side menu event handler
- (void)drawerButtonPressed {
    [self.view endEditing:YES];
    [self.viewDeckController toggleLeftViewAnimated:YES];
}


-(IBAction)showCameraAction:(id)sender {
    // Lazily allocate image picker controller
    if (!imagePickerController) {
        imagePickerController = [[UIImagePickerController alloc] init];
        
        // If our device has a camera, we want to take a picture, otherwise, we just pick from
        // photo library
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        } else {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        
        // image picker needs a delegate so we can respond to its messages
        [imagePickerController setDelegate:self];
    }
    // Place image picker on the screen
    [self presentModalViewController:imagePickerController animated:YES];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    // remove overlay
    //[self dismissModalViewControllerAnimated:YES];
    
    // Send post data
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if(image){
        NSLog(@"asdf");
    }
    
    
    // checks for internet connection
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus == NotReachable) {
        //there-is-no-connection warning
        NSLog(@"Internet connection NOT available");
    } else {
        //my web-dependent code
        NSLog(@"Internet connection IS available");
        
        
        
        
        NSString *filename = [NSString stringWithFormat:@"something.png"];
        
        // random number for cachebusting
        int randomNumber = arc4random() % 999999999;
        
        // need to parse the url because pipes in the url cause errors
        NSString *unDecodedURL =[NSString stringWithFormat:@"http://cosmos.is:81/api/service/upload_image/"];
        NSURL *decodedUrl = [NSURL URLWithString:[unDecodedURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        /*
         NSLog(@"url: %@", unDecodedURL);
         
         
         NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:decodedUrl];
         request.HTTPMethod = @"POST";
         
         
         
         
         
         
         
         NSString *boundary = @"---------------------------14737809831466499882746641449";
         NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
         [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
         
         NSMutableData *body = [NSMutableData data];
         
         
         
         // file
         [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
         [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; type=\"filedata\"; name=\"filedata\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
         [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
         [body appendData:imageData];
         
         
         
         // caption
         [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
         [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_image_caption\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
         [body appendData:[[NSString stringWithFormat:@"caption goes here"] dataUsingEncoding:NSUTF8StringEncoding]];
         
         
         // image source
         [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
         [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_image_source\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
         [body appendData:[[NSString stringWithFormat:@"iOS App"] dataUsingEncoding:NSUTF8StringEncoding]];
         
         
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
         //[request setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
         
         NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request
         delegate:self];
         if(connection) {
         NSLog(@"hi");
         NSMutableData *mutableData = [[NSMutableData alloc] init];
         }
         */
        
        // setting up the request object now
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:decodedUrl];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        
        
        // file
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; type=\"filedata\"; name=\"filedata\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        
        
        
        // caption
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_image_caption\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"caption goes here"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        // image source
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_image_source\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"iOS App"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
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
        
        /* */
        
        /*NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request
         delegate:self
         startImmediately:YES];
         */
        
        
        
        
        
        
    }
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    long long expLength = [response expectedContentLength];
    
    NSLog(@"content-length: %lld bytes", expLength);
    
    
    NSString *lastModifiedString = nil;
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
        lastModifiedString = [[httpResponse allHeaderFields] objectForKey:@"Last-Modified"];
        NSLog(@"hi : %@", [httpResponse allHeaderFields] );
        
        
    }
    // [Here is where the formatting-date-code and downloading would take place]
}
/*
 - (void)connection:(NSURLConnection*)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
 {
 NSLog(@"didSendBodyData");
 }
 */
/*
 if data is successfully received, this method will be called by connection
 */
/*
 - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
 //[self.resourceData appendData:data];
 
 NSNumber *resourceLength = [NSNumber numberWithUnsignedInteger:[self.resourceData length]];
 NSLog(@"resourceData length: %d", [resourceLength intValue]);
 NSLog(@"filesize: %d", self.filesize);
 NSLog(@"float filesize: %f", [self.filesize floatValue]);
 progressView.progress = [resourceLength floatValue] / [self.filesize floatValue];
 NSLog(@"progress: %f", [resourceLength floatValue] / [self.filesize floatValue]);
 }
 
 
 - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
 //[self.resourceData setLength:0];
 
 NSNumber *filesize = [NSNumber numberWithLongLong:[response expectedContentLength]];
 NSLog(@"content-length: %@ bytes", filesize);
 }
 
 - (void) connection: (NSURLConnection*) connection didReceiveData: (NSData*) data
 {
 //[data_ appendData: data];
 NSNumber *num = ([data length] / 100000);
 // Broadcast a notification with the progress change, or call a delegate
 }
 
 
 - (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
 {
 long long contentLength = [response expectedContentLength];
 NSLog(@"hi: %lld", contentLength);
 }
 
 - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
 
 
 NSLog(@"Connection received data, retain count: %@", connection);
 }
 
 - (void)connectionDidFinishLoading:(NSURLConnection *)connection{
 NSLog(@"finished connection retain count:  %@", connection);
 }
 
 - (void)setProgress:(float)newProgress {
 //    [prgressView setProgress:newProgress];
 NSLog(@"New progress: %f", newProgress);
 }
 
 - (void)didCompleteRequestService:(ASIHTTPRequest *)request
 {
 NSLog(@"Request completed");
 NSLog(@"Result: %@", request.responseString);
 }
 */

@end