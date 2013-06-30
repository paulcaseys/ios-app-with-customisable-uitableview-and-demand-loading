//
//  LoginNewAccountViewController.m
//  iOSApp
//
//  Created by PAUL CASEY on 2013-06-26.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import "LoginNewAccountViewController.h"

#import "NSDictionary+QueryStringBuilder.h"

#import "IIViewDeckController.h"
#import "Reachability.h"

#import <QuartzCore/QuartzCore.h>

@interface LoginNewAccountViewController ()

@end

@implementation LoginNewAccountViewController
@synthesize _object;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.title = @"webservice";
    
    // placeholders in textfields
	[texterUsername setPlaceholder:@"Username"];
    [texterUsername setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
	[texterPassword setPlaceholder:@"Password"];
    [texterPassword setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
	[texterEmail setPlaceholder:@"Email address"];
    [texterEmail setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    // adds error label
    errorLabel.text = @"";
    
    // sets focus
    [texterUsername becomeFirstResponder];
    
    // adds the next button
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"sign up" style:UIBarButtonItemStylePlain target:self action:@selector(initialiseCosmosSubmission)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}
-(void)viewDidUnload{    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// submitting item into project
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
            errorLabel.text = @"Please complete all fields";
        } else {
            errorLabel.text = @"Creating account...";
            
            // creates an async queue, so the page can be displayed before loading is complete
            dispatch_queue_t feedQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(feedQueue, ^{
                
                // define form values
                NSString *external_reference_string = texterUsername.text;
                NSString *detail_EmailAddress = texterEmail.text;
                NSString *detail_Password = texterPassword.text;
                
                
                // random number for cachebusting
                int randomNumber = arc4random() % 999999999;
                NSString *randomNumberString = [NSString stringWithFormat:@"%i", randomNumber];
                
                // defining parameters
                NSDictionary *queryParameters = @{@"project_name" : @"iOSAppProjectExample",
                                                  @"project_password" : @"b816af010d9567864542020d6c7073ce",
                                                  @"external_reference_string" : external_reference_string,
                                                  @"cosmos_force" : @"",
                                                  @"cacheBuster" : randomNumberString,
                                                  
                                                  @"detail_MessageId" : @"",
                                                  @"detail_ImageFile" : @"",
                                                  @"detail_ImageDescription" : @"",
                                                  @"detail_Name" : @"",
                                                  @"detail_FirstName" : @"",
                                                  @"detail_LastName" : @"",
                                                  @"detail_HomePhoneNumber" : @"",
                                                  @"detail_EmailAddress" : detail_EmailAddress,
                                                  @"detail_Address" : @"",
                                                  @"detail_Address2" : @"",
                                                  @"detail_Suburb" : @"",
                                                  @"detail_Postcode" : @"",
                                                  @"detail_State" : @"",
                                                  @"detail_Country" : @"",
                                                  @"detail_DateOfBirth" : @"",
                                                  @"detail_Gen1" : @"true",
                                                  @"detail_Gen2" : @"false",
                                                  @"detail_Gen3" : @"",
                                                  @"detail_Gen4" : @"",
                                                  @"detail_Gen5" : @"",
                                                  @"detail_Gen6" : @"",
                                                  @"detail_Gen7" : @"",
                                                  @"detail_Gen8" : @"",
                                                  @"detail_Gen9" : @"",
                                                  @"detail_Gen10" : @"",
                                                  @"detail_Password" : detail_Password,
                                                  @"classification_1" : @"",
                                                  @"classification_2" : @"",
                                                  @"classification_3" : @"",
                                                  @"classification_4" : @"",
                                                  @"classification_5" : @"",
                                                  @"page_title" : @"",
                                                  @"page_summary" : @"",
                                                  @"page_body_text" : @"",
                                                  @"page_image_url" : @"",
                                                  @"detail_Hook1" : @"",
                                                  @"detail_Hook2" : @"",
                                                  @"detail_Hook3" : @""};
                
                // need to parse the url because pipes in the url cause errors
                NSString *unDecodedURL =[NSString stringWithFormat:@"http://cosmos.is:81/api/service/save/format/json/%@", [queryParameters queryString]];
                NSURL *decodedUrl = [NSURL URLWithString:[unDecodedURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
                NSData *url = [NSData dataWithContentsOfURL:decodedUrl];
                
                //NSLog(@"url: %@", unDecodedURL);
                
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
                        NSLog(@"loading complete: form entry!");
                        NSLog(@"jsonResponse: %@", jsonResponse);
                        
                        errorLabel.text = @"Finalising...";
                        NSString *external_reference_string = [jsonResponse valueForKey:@"external_reference_string"];
                        NSString *unique_reference_id = [jsonResponse valueForKey:@"unique_reference_id"];
                        NSString *type_of_unique_reference_data = [jsonResponse valueForKey:@"type_of_unique_reference_data"];
                        
                        NSLog(@"external_reference_string: %@", external_reference_string);
                        NSLog(@"unique_reference_id: %@", unique_reference_id);
                        NSLog(@"type_of_unique_reference_data: %@", type_of_unique_reference_data);
                        
                        // check if username is unique
                        if([type_of_unique_reference_data isEqual: @"a new unique_reference was inserted"]){
                            NSLog(@"SUCCESS: username is unique");
                            errorLabel.text = @"New account created! Please wait while signing in...";
                            
                        } else {
                            NSLog(@"ERROR: username is not unique");
                            [self addInvalidStyle:texterUsername];
                            errorLabel.text = @"Sorry, that username is taken.";
                            
                        }
                        
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
    
    [self removeInvalidStyle:texterUsername];
    [self removeInvalidStyle:texterPassword];
    [self removeInvalidStyle:texterEmail];
    
    if([texterUsername.text isEqualToString:@""]){
        formErrors = YES;
        [self addInvalidStyle:texterUsername];
    }
    if([texterPassword.text isEqualToString:@""]){
        formErrors = YES;
        [self addInvalidStyle:texterPassword];
    }
    if([texterEmail.text isEqualToString:@""]){
        formErrors = YES;
        [self addInvalidStyle:texterEmail];
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


@end
