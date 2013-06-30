//
//  WebserviceViewController.m
//  iOSApp
//
//  Created by PAUL CASEY on 2013-06-23.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import "WebserviceViewController.h"

#import "IIViewDeckController.h"
#import "Reachability.h"

#import <QuartzCore/QuartzCore.h>

@interface WebserviceViewController ()

@end

@implementation WebserviceViewController
@synthesize _object;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    // Google analytics event tracking
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Profile Screen"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    // menu button
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"drawer.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(drawerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 52, 44)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.title = @"webservice";
    
    // placeholders in textfields
	[texterFirstName setPlaceholder:@"First Name"];
    [texterFirstName setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
	[texterLastName setPlaceholder:@"Last Name"];
    [texterLastName setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    // adds error label
    errorLabel.text = @"";
    
    // sets focus
    [texterFirstName becomeFirstResponder];
    
    // adds the next button
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"next" style:UIBarButtonItemStylePlain target:self action:@selector(initialiseCosmosSubmission)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
        
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
            errorLabel.text = @"Please complete the form";
        } else {
            errorLabel.text = @"Submitting form";
            
            // creates an async queue, so the page can be displayed before loading is complete
            dispatch_queue_t feedQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(feedQueue, ^{
                
                // define form values
                NSString *details_firstName = texterFirstName.text;
                NSString *details_lastName = texterLastName.text;
                
                // random number for cachebusting
                int randomNumber = arc4random() % 999999999;
                
                // need to parse the url because pipes in the url cause errors
                NSString *unDecodedURL =[NSString stringWithFormat:@"http://cosmos.is/api/service/save/format/json/?detail_MessageId=&detail_ImageFile=&detail_ImageDescription=&detail_DateReceived=&detail_Name=&detail_FirstName=%@&detail_LastName=%@&detail_HomePhoneNumber=+&detail_EmailAddress=+&detail_Address=+&detail_Address2=&detail_Suburb=&detail_Postcode=+&detail_State=+&detail_Country=&detail_DateOfBirth=&detail_Gen1=true&detail_Gen2=false&detail_Gen3=&detail_Gen4=&detail_Gen5=&detail_Gen6=&detail_Gen7=&detail_Gen8=&detail_Gen9=&detail_Gen10=&classification_1=&classification_2=&classification_3=&classification_4=&classification_5=&page_title=&page_summary=&page_body_text=&page_image_url=&project_name=iOSAppProjectExample&project_password=b816af010d9567864542020d6c7073ce&external_reference_string=&cosmos_force=1&cacheBuster=%d", details_firstName, details_lastName, randomNumber];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// FORM VALIDATION
// returns over 0, if there is an error
- (BOOL)validateForm {
    
    // defines how many errors there are
    BOOL formErrors = NO;
    
    // removes all the invalid styles first
    
    [self removeInvalidStyle:texterFirstName];
    [self removeInvalidStyle:texterLastName];
    
    if([texterFirstName.text isEqualToString:@""]){
        formErrors = YES;
        [self addInvalidStyle:texterFirstName];
    }
    if([texterLastName.text isEqualToString:@""]){
        formErrors = YES;
        [self addInvalidStyle:texterLastName];
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


// EVENT HANDLERS
#pragma mark - Event handlers

// side menu event handler
- (void)drawerButtonPressed {
    [self.view endEditing:YES];
    [self.viewDeckController toggleLeftViewAnimated:YES];
}


- (IBAction)submitFormButtonTapHandler:(id)sender {
    [self.view endEditing:YES];
    [self initialiseCosmosSubmission];
    //[self.viewDeckController toggleLeftViewAnimated:YES];
}

@end
