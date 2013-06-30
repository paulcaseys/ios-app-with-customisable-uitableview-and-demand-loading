//
//  LoginEntryViewController.m
//  iOSApp
//
//  Created by PAUL CASEY on 2013-06-26.
//  Copyright (c) 2013 PAUL CASEY. All rights reserved.
//

#import "LoginEntryViewController.h"

#import "NSDictionary+QueryStringBuilder.h"

#import "IIViewDeckController.h"
#import "Reachability.h"

#import <QuartzCore/QuartzCore.h>

@interface LoginEntryViewController ()

@end

@implementation LoginEntryViewController
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
    
    
    
    self.title = @"sign in";
    
    // placeholders in textfields
	[texterUsername setPlaceholder:@"Username"];
    [texterUsername setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
	[texterPassword setPlaceholder:@"Password"];
    [texterPassword setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    // adds error label
    errorLabel.text = @"";
    
    // sets focus
    [texterUsername becomeFirstResponder];
    
    // adds the next button
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"sign in" style:UIBarButtonItemStylePlain target:self action:@selector(initialiseLogin)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// logging in
- (void)initialiseLogin {
	
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
            errorLabel.text = @"Logging in...";
            
            // creates an async queue, so the page can be displayed before loading is complete
            dispatch_queue_t feedQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(feedQueue, ^{
                
                // define form values
                NSString *external_reference_string = texterUsername.text;
                NSString *detail_Password = texterPassword.text;
                
                
                // random number for cachebusting
                int randomNumber = arc4random() % 999999999;
                NSString *randomNumberString = [NSString stringWithFormat:@"%i", randomNumber];
                
                // defining parameters
                NSDictionary *queryParameters = @{@"project_name" : @"iOSAppProjectExample",
                                                  @"project_password" : @"b816af010d9567864542020d6c7073ce",
                                                  @"external_reference_string" : external_reference_string,
                                                  @"detail_Password" : detail_Password,
                                                  @"cacheBuster" : randomNumberString
                                                  };
                
                // need to parse the url because pipes in the url cause errors
                NSString *unDecodedURL =[NSString stringWithFormat:@"http://cosmos.is:81/api/service/check_password/format/json/%@", [queryParameters queryString]];
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
                        
                        NSString *Response = @"";
                        
                        
                        Response = [jsonResponse valueForKey:@"Response"];
                        
                        NSLog(@"Response: %@", Response);
                        
                        // check if username is unique
                        if([Response isEqual: @"correct"]){
                            NSLog(@"SUCCESS: password correct");
                            errorLabel.text = @"Password correct";
                            [self dismissModalViewControllerAnimated:YES];
                            
                        } else {
                            NSLog(@"ERROR: password or username is not correct");
                            [self addInvalidStyle:texterUsername];
                            [self addInvalidStyle:texterPassword];
                            errorLabel.text = @"Password or username is incorrect.";
                            
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
