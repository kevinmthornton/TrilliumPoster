//
//  InfoViewController.m
//  NavigationScroll
//
//  Created by Kevin Thornton on 4/10/12.
//  Copyright (c) 2012 radisys. All rights reserved.
//

#import "AppDelegate.h"
#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController
@synthesize appDelegate;
@synthesize infoWebView;
@synthesize detailItem = _detailItem;
@synthesize buttonTitle;

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {  
    // NSLog(@"made it into shouldStartLoadWithRequest");
    // Make sure it's a link click that called this function.
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        NSURL *requestURL = [ request URL ];  
        if ([self connectedToInternet]) {
            // NSLog(@"yes, we have an internet connection");
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection" message:@"You do not have an internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            return NO;
        }
        
        //send to appDelegate to open the nav controller with this link
        [appDelegate openNavControllerLink:requestURL];
        return NO;
        
     } else { // from if navigationType 
        // default, just in case
        return YES;
    }
} 

// open the links from the buttons for the nav top and bottom right
- (IBAction)openWebLink:(UIButton *)sender {
    NSURL *linkURL = [[NSURL alloc] init];
    
    if ([sender.currentTitle isEqualToString:@"Intel"]) {
        linkURL = [NSURL URLWithString: @"http://www.intel.com/design/network/ica/"];
    } else if ([sender.currentTitle isEqualToString:@"Trillium"]) {
        linkURL = [NSURL URLWithString: @"http://www.radisys.com/Products/Trillium.html"];
    } else {
        linkURL = [NSURL URLWithString: @"http://www.radisys.com/"];
    }
    
    // open this in safari
    [[ UIApplication sharedApplication ] openURL: linkURL];
    
}


// do they have an internet connection?
- (BOOL) connectedToInternet {     
    NSError *urlError = [[NSError alloc] init];
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"] encoding:NSUTF8StringEncoding error:&urlError];
    return ( URLString != NULL ) ? YES : NO;
    
}

// called 2nd: Update the user interface for the detail item. Do this here so you can reload and clear out the cache of values
- (void)configureView {
    
    if (self.detailItem) {    
        // set up the view with values from the Info.xml file based on which button was clicked
        infoWebView.dataDetectorTypes=UIDataDetectorTypeAddress;
        buttonTitle = [[NSString alloc] initWithFormat:@"%@", [self.detailItem description]];
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        // no need for this since we are clearing out the _mainWebView in ViewController
        // [self.infoWebView loadHTMLString:nil baseURL:baseURL];
        
        // now load in the real HTML
        // NSLog(@"buttonTitle: %@", buttonTitle);
        NSError *errMsg = nil; // pointer to the error message which we use in initWithContentsOfURL
        NSStringEncoding encodingMsg; // general encoding method for initWithContentsOfURL
        
        // set up base HTML/CSS
        NSURL *baseHTMLURL = [[NSBundle mainBundle] URLForResource:@"webview" withExtension:@"html"];
        NSString *baseHTML = [[NSString alloc] initWithContentsOfURL:baseHTMLURL usedEncoding:&encodingMsg error:&errMsg];
        
        // this won't work in configureView for some reason like NetworkDetailView and I can't figure out why
        // now which button was this? open xml file and load up the XML based on the title
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"Info" withExtension:@"xml"];
        // set up the dictionary
        NSDictionary *infoDictionary = [[NSDictionary alloc ] initWithContentsOfURL:fileUrl];
        // get the values from the infoDicitonary based on the title of the button
        
        NSString *infoHTMLValue = [[NSString alloc] initWithFormat:@"%@",[infoDictionary objectForKey:buttonTitle] ];
        // create a string to concat the baseHTML and the info from the XML file
        NSString *finalInfoHMTL = [[NSString alloc] init];
        // concat info and base html together
        finalInfoHMTL = [baseHTML stringByAppendingString:infoHTMLValue];
        [self.infoWebView loadHTMLString:finalInfoHMTL baseURL:baseURL]; // load it up
        // NSLog(@"configureView - finalInfoHMTL: %@", finalInfoHMTL);


    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // set up our appDelegate var so we can reference the methods there
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    // set the delegation!! this must be here for shouldStartLoadWithRequest to work along with the UIWebViewDelegate in the .h file
    [infoWebView setDelegate:self];
    
    // won't load the first time?
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    // [self.infoWebView loadHTMLString:nil baseURL:baseURL];
    
    // now load in the real HTML
    // NSLog(@"buttonTitle: %@", buttonTitle);
    NSError *errMsg = nil; // pointer to the error message which we use in initWithContentsOfURL
    NSStringEncoding encodingMsg; // general encoding method for initWithContentsOfURL
    
    // set up base HTML/CSS
    NSURL *baseHTMLURL = [[NSBundle mainBundle] URLForResource:@"webview" withExtension:@"html"];
    NSString *baseHTML = [[NSString alloc] initWithContentsOfURL:baseHTMLURL usedEncoding:&encodingMsg error:&errMsg];
    
    // this won't work in configureView for some reason like NetworkDetailView and I can't figure out why
    // now which button was this? open xml file and load up the XML based on the title
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"Info" withExtension:@"xml"];
    // set up the dictionary
    NSDictionary *infoDictionary = [[NSDictionary alloc ] initWithContentsOfURL:fileUrl];
    // get the values from the infoDicitonary based on the title of the button
    
    NSString *infoHTMLValue = [[NSString alloc] initWithFormat:@"%@",[infoDictionary objectForKey:buttonTitle] ];
    // create a string to concat the baseHTML and the info from the XML file
    NSString *finalInfoHMTL = [[NSString alloc] init];
    // concat info and base html together
    finalInfoHMTL = [baseHTML stringByAppendingString:infoHTMLValue];

    [self.infoWebView loadHTMLString:finalInfoHMTL baseURL:baseURL]; // load it up
}

// called 1st from ViewController to set up the buttonTitle var
// that is what determines which node of the XML to open
- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

/*
 // for the top buttons: About, Contact, Order Poster, Questions
 // use the main vc for all these funtions
 -(IBAction)getInfo:(UIButton *)sender {
 // set up base path and URL
 NSString *path = [[NSBundle mainBundle] bundlePath];
 NSURL *baseURL = [NSURL fileURLWithPath:path];
 NSError *errMsg = nil;
 NSStringEncoding encodingMsg;
 
 // set up base HTML/CSS
 NSURL *baseHTMLURL = [[NSBundle mainBundle] URLForResource:@"webview" withExtension:@"html"];
 NSString *baseHTML = [[NSString alloc] initWithContentsOfURL:baseHTMLURL usedEncoding:&encodingMsg error:&errMsg];
 // now which button was this? load up the XML based on the title
 // open xml file and get data
 NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"Info" withExtension:@"xml"];
 // set up the dictionary
 NSDictionary *infoDictionary = [[NSDictionary alloc ] initWithContentsOfURL:fileUrl];
 // get the values from the abbvString in the letterDicitonary; this gives you all the values in one dicitonary that you can pull apart
 NSString *infoHTMLValue = [[NSString alloc] initWithFormat:@"%@",[infoDictionary objectForKey:sender.currentTitle] ];
 
 NSString *finalInfoHMTL = [[NSString alloc] init];
 finalInfoHMTL = [baseHTML stringByAppendingString:infoHTMLValue];
 
 // [self.infoWebView loadHTMLString:infoHTMLValue baseURL:baseURL]; //[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]
 [self.infoWebView loadHTMLString:finalInfoHMTL baseURL:baseURL];
 }
 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
