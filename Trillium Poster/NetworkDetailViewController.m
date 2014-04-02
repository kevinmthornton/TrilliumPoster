//  NetworkDetailViewController.m
/*
 this is the view from the glossary table
 once you click on an element in a network, this is what is shown from the .xib file and configure view
 you use PDFView in order to get links
 shouldStartLoadWithRequest will parse the links for either inside web view or outside(safari) loading
 */

#import "NetworkDetailViewController.h"
#import "ViewController.h"
#import "InfoViewController.h"
// #import "PDFView.h"

@implementation NetworkDetailViewController
@synthesize backButton;
@synthesize networkDetailWebView;
@synthesize resourcesWebView; // must be weak and NOT in the {} for the interface in the .h file so that we can use shouldStartLoadWithRequest
@synthesize productPhoto = _productPhoto;
@synthesize stackImage = _stackImage;
@synthesize backgroundNetworkDetailPortrait = _backgroundNetworkDetailPortrait;
@synthesize backgroundNetworkDetailLandscape = _backgroundNetworkDetailLandscape;
@synthesize detailItem = _detailItem;
@synthesize fileIndex, abbvString, letters, appDelegate, mainViewController, productImageName, stackImageName, resourcesYUP, resourcesYDown, resourcesWebFrameY;
@synthesize infoViewController = _infoViewController;
@synthesize backButtonNetwork = _backButtonNetwork;

// @synthesize pdfView = _pdfView;

@synthesize resourcesButton;

- (void)configureView {
    // Update the user interface for the detail item. Do this here so you can reload and clear out the cache of values
    if (self.detailItem) {    
        // set up the view with values from MAIN view controller
        // abbvString was set in main view controller
        
        // set up the letters array FROM APPDELEGATE!!!!!!
        appDelegate = [[UIApplication sharedApplication] delegate];
        letters = appDelegate.lettersAppArray;
        
        // set web views to be delegates of themselves so that they can use shouldStartLoadWithRequest for links
        // shouldStartLoadWithRequest hooks in with PDFView which goes outside to get links
        [networkDetailWebView setDelegate:self];
        [resourcesWebView setDelegate:self];
        
        // get the file letter out with fileIndex which was set up in ViewController.openNetworkDetailView with setFileIndex
        NSString *stringLetter = [letters objectAtIndex:fileIndex];
//        NSLog(@"NDVC.configureView - fileIndex: %i",fileIndex);
//        NSLog(@"NDVC.configureView - string letter: %@",stringLetter);
        
        // OK, now the work starts. Load up the file from the fileIndex, grab it's contents and get the values from the [self.detailItem description]
        // grab this file out of the resources folder
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:stringLetter withExtension:@"xml"];
        // set up the dictionary
        NSDictionary *letterDictionary = [[NSDictionary alloc ] initWithContentsOfURL:fileUrl];
//        NSLog(@"NDVC.configureView - letter dict: %@",letterDictionary);

        // get the values from the abbvString in the letterDicitonary; this gives you all the values in one dicitonary that you can pull apart
        NSDictionary *glossaryValuesDictionary = [[NSDictionary alloc] initWithDictionary:[letterDictionary objectForKey:abbvString] copyItems:YES ];
        
        //assign all the values to strings that will be concatenated together to form the final networkDetailFinalString
        NSString *networkDetailFinalString = [[NSString alloc] init];
        // main element name wrapped in HTML/CSS
        NSString *elementName = [[NSString alloc] initWithFormat:@"<p><span class='title-process-label'>%@</span></p>", [glossaryValuesDictionary objectForKey:@"elementName"]];
//        NSLog(@"NDVC.configureView - elementName: %@",elementName);
        /*
         one web view that is tall and the only one.
         we concat the values from the XML together to make an HTML string that we load into the one large view
        */
        
        
        // set up base URL vars
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        NSURL *baseHTMLURL = [[NSBundle mainBundle] URLForResource:@"webview" withExtension:@"html"];
        NSError *errMsg = nil;
        NSStringEncoding encodingMsg; // NOT an object
        NSString *baseHTML = [[NSString alloc] initWithContentsOfURL:baseHTMLURL usedEncoding:&encodingMsg error:&errMsg];
        
        // start off the final networkDetailWebView string with the webview.html file concatenated with the elementName wrapped in HTML
        networkDetailFinalString = [baseHTML stringByAppendingString:elementName];
        
        // get the values from the educationalDescription in the glossaryValuesDictionary; this gives back HTML
        NSString *eduHTMLValue = [[NSString alloc] initWithFormat:@"%@",[glossaryValuesDictionary objectForKey:@"educationalDescription"]];
        // NSLog(@"eduHTMLValue: %@", eduHTMLValue);
        networkDetailFinalString = [networkDetailFinalString stringByAppendingString:eduHTMLValue];
        
        /* NOTHING in radisysSolution for now so, commented out. 2nd Version?
        // get the values from the radisysSolution; this gives back HTML
        NSString *solutionHTMLValue = [[NSString alloc] initWithFormat:@"%@",[glossaryValuesDictionary objectForKey:@"radisysSolution"]];
        if (![solutionHTMLValue isEqualToString:@""]) {
            networkDetailFinalString = [networkDetailFinalString stringByAppendingString:@"<span class='header'>Overview</span>"];
        }
        networkDetailFinalString = [networkDetailFinalString stringByAppendingString:solutionHTMLValue];
        */
        
        // get the values from the radisysSolution; this gives back HTML
        NSString *productsHTMLValue = [[NSString alloc] initWithFormat:@"%@",[glossaryValuesDictionary objectForKey:@"products"]];
        if (![productsHTMLValue isEqualToString:@""]) {
            networkDetailFinalString = [networkDetailFinalString stringByAppendingString:@"<span class='header'>Radisys Products</span>"];
        }
        
        networkDetailFinalString = [networkDetailFinalString stringByAppendingString:productsHTMLValue];
        // NSLog(@"final: %@", networkDetailFinalString);
        // NETWORK DETAIL WEB VIEW
        // set up the left panel background image
//        UIImageView *backgroundNetworkDetail = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"networkDetail_left_panel.png"]]; //init a background
//        [self.networkDetailWebView setOpaque:NO];
//        [self.networkDetailWebView setBackgroundColor:[UIColor clearColor]];
//        [self.networkDetailWebView addSubview: backgroundNetworkDetail];                //add the background to our mainview
//        [self.networkDetailWebView sendSubviewToBack:backgroundNetworkDetail];          //move the background view to the back of UIWebView
        // put the final string into the MAIN networkDetailWebView
        [self.networkDetailWebView  loadHTMLString:networkDetailFinalString baseURL:baseURL];
        
        // STACK IMAGE
        [self setStackImageName:nil];
        stackImageName = [[NSString alloc] initWithFormat:@"%@",[glossaryValuesDictionary objectForKey:@"stack"]];
        // NSLog(@"stackImageName: %@", stackImageName);
        
        // check to see if there and if not, insert a blank one
        if ([stackImageName isEqualToString:@""]) {
            stackImageName = [[NSString alloc] initWithFormat:@"blank.png"];
        }
        
        [self.stackImage addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:stackImageName]]];
        
        // PRODUCT IMAGE
        [self setProductImageName:nil];
        productImageName = [[NSString alloc] initWithFormat:@"%@",[glossaryValuesDictionary objectForKey:@"photo"]];
        // NSLog(@"productImageName: %@", productImageName);
        
        // check to see if there and if not, insert a blank one
        if ([productImageName isEqualToString:@""]) {
            productImageName = [[NSString alloc] initWithFormat:@"blank.png"];
        }
        
        [self.productPhoto addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:productImageName]]];

        // BACK BUTTON
        [self setBackButtonNetwork:nil];
        backButtonNetwork = [[NSString alloc] initWithFormat:@"%@",[glossaryValuesDictionary objectForKey:@"network"]];
        
        // RESOURCES VIEW
        // set up the resources background image 
        UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"networkDetail_right_panel.png"]]; //init a background
        [self.resourcesWebView setOpaque:NO];
        [self.resourcesWebView setBackgroundColor:[UIColor clearColor]];
        [self.resourcesWebView addSubview: background];            //add the background to our mainview
        [self.resourcesWebView sendSubviewToBack:background];            //move the background view to the back of UIWebView
        
        // add the button for the resources up/down action
        resourcesButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        // set up the frame placement and the size
        resourcesButton.frame = CGRectMake(15, 5, 100, 40);
        // set up the method for moving this resources view up and down
        [resourcesButton addTarget:self action:@selector(showResourcesWebView:) forControlEvents:UIControlEventTouchUpInside];
        
        // put this on the resourcesWebView
        [self.resourcesWebView addSubview:resourcesButton];
        
        // get the values from the resources section in the radisysSolution; this gives back HTML
        NSString *resourcesFinalString = [[NSString alloc] init];
        resourcesFinalString = [resourcesFinalString stringByAppendingString:baseHTML];
        resourcesFinalString = [resourcesFinalString stringByAppendingString:@"<span class='title-process-label'>Resources</span>"];
        NSString *resourcesHTMLValue = [[NSString alloc] initWithFormat:@"%@",[glossaryValuesDictionary objectForKey:@"resources"]];
        resourcesFinalString = [resourcesFinalString stringByAppendingString:resourcesHTMLValue];
        [self.resourcesWebView loadHTMLString:resourcesFinalString baseURL:baseURL];
        
        
        /*
         [glossaryValuesDictionary objectForKey:@"Connection"]
         this will return you the object for that key. this can be anything, a string, array or dict
         you will return this into an object that you create, IE: connectionArray, and then you can work with it 
         Here is what is in the xml file:
         <key>Connection</key>
         <array>
         <string>PPP</string>
         <string>DDD</string>
         <string>CCC</string>
         <string>EEE</string>
         <string>RRR</string>
         </array>
         
         */ 
        
        /*
         //PROTOCOL STACKS - not implemented yet
         // now get the arrays from the stacks if there are any values
         // this array is all the connections for the protoal stack
         NSArray *connectionArray = [[NSArray alloc] initWithArray:[glossaryValuesDictionary objectForKey:@"Connection"]];
         // NSLog(@"connectionArray: %@", connectionArray);
         // now you have to dynamically make buttons that stack on top of each other and hook to a method that will show the definition
         // the button has to have a tag(fileIndex) and a title([self.detailItem description])
         float startX = 300.;
         float startY = 300.;
         float buttonWidth = 100.;
         float buttonHeight = 25.;
         
         for (NSString *buttonName in connectionArray) {
         // NSLog(@"buttonName: %@", buttonName);
         // place the button on the view on top of each other
         UIButton *connectionButton =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
         // set up the frame placement and the size
         connectionButton.frame = CGRectMake(startX, startY, buttonWidth, buttonHeight);
         // set up the title for the button
         [connectionButton setTitle:buttonName forState:UIControlStateNormal];
         // set up the tag for the button from the first character of the title
         // string manipulation - get the first character of the title and convert it to lower case
         // grab the char
         char c = [buttonName characterAtIndex:0];
         // NSLog(@"c: %c",c);
         // convert it to a string for use in indexOfObject
         NSString *firstChar=[[NSString alloc] initWithFormat:@"%c",c];
         // NSLog(@"firstChar: %@", firstChar);
         
         // grad the index value of firstChar; must be an int!!!
         int firstCharInt = [letters indexOfObject:firstChar];
         // NSLog(@"firstCharInt: %d", firstCharInt);
         // assign the index value to the button tag
         [connectionButton setTag:firstCharInt];
         
         
         // assign this button a method for when pressed
         [connectionButton addTarget:self action:@selector(showButtonDetail:) forControlEvents:UIControlEventTouchUpInside];
         
         // this will set the method up that the button presses in order to get the glossary pop up
         // you will have to set the tag and title so that you can pass this on
         // http://stackoverflow.com/questions/1378765/how-do-i-create-a-basic-uibutton-programmatically
         // [button addTarget:self action:@selector(BUTTONPRESSED:)forControlEvents:UIControlEventTouchDown];
         [self.view addSubview:connectionButton];
         // no increment the startY to move the buttons down by the same size as there height
         startY += 25.;
         }
         */
    } 
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {  
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
//        NSLog(@"shouldStartLoadWithRequest: %@", requestURL);
//        [appDelegate openNavControllerLink:requestURL];
        
//      NOTIFICATION for opening a web link
        // NOTIFICATION - NOTIFICATION_OPEN_NETWORK_VIEW is set up in the Trillium-Prefix.pch file
        // set up our array for URL in the notification dictionary
        // need to be the same number and match
        NSArray *values = [NSArray arrayWithObjects:((NSURL *)requestURL), nil];
        NSArray *keys = [NSArray arrayWithObjects:@"URL", nil];
        // load up the dictionary with these two arrays
        NSDictionary *notificationInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        
        // you can now set up a listener for NOTIFICATION_BACK_BUTTON in any view controller > viewDidLoad
        // object in the call below could be ANY OBJECT, in this case, it is a dicitonary
        NSNotification *notification = [NSNotification notificationWithName:NOTIFICATION_OPEN_NAV_CONTROLLER_LINK object:notificationInfo];
        // posts the notification to the defaultCenter
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        return NO;
        
    } else { // from if navigationType 
        // default, just in case
        return YES;
    }
} 

// BACK BUTTON - close this detial view and go back to the network view
-(IBAction)closeViewAndReturnToNetwork:(UIButton *)sender {
    [self.view removeFromSuperview];
//    this should be done differently if you have time - CONTAINER view controllers
    [self.backButton setTitle:backButtonNetwork forState:UIControlStateNormal];
    
    // NOTIFICATION - NOTIFICATION_BACK_BUTTON is set up in the Trillium-Prefix.pch file
    // set up our arrays for title, tag combintations for the notification dictionary
    // need to be the same number and match
    NSArray *values = [NSArray arrayWithObjects:((UIButton *)sender.currentTitle), [NSNumber numberWithInteger:sender.tag], nil];
    NSArray *keys = [NSArray arrayWithObjects:@"title", @"tag", nil];
    // load up the dictionary with these two arrays
    NSDictionary *notificationInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    
    NSArray *testArrray = [notificationInfo allKeys];
    
    // you can now set up a listener for NOTIFICATION_BACK_BUTTON in any view controller > viewDidLoad
    // object in the call below could be ANY OBJECT, in this case, it is a dicitonary
    NSNotification *notification = [NSNotification notificationWithName:NOTIFICATION_OPEN_NETWORK_VIEW object:notificationInfo];
    // posts the notification to the defaultCenter
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


// do they have an internet connection?
- (BOOL) connectedToInternet {     
    NSError *urlError = [[NSError alloc] init];
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"] encoding:NSUTF8StringEncoding error:&urlError];
    return ( URLString != NULL ) ? YES : NO;
}

- (void) reloadHtml {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *html = [self.networkDetailWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    
    if(html == nil || [html isEqualToString:@""] || [html length] < 100) [self.networkDetailWebView reload];
    
    [self.networkDetailWebView loadHTMLString:html baseURL:baseURL];
}
#pragma mark - View lifecycle

// for changing oreientation and moving views around
-(void)reconfigurePortrait{
    [self.view setFrame:CGRectMake(0, 0, 760, 1024)];
    CGPoint portraitCenter = CGPointMake(375, 560);
    [self.view setCenter:portraitCenter];
    [self.networkDetailWebView setFrame:CGRectMake(0, 0, 0, 0)];
    [self.networkDetailWebView setFrame:CGRectMake(5, 90, 360, 785)];
    [self.networkDetailWebView stringByEvaluatingJavaScriptFromString:
     [NSString stringWithFormat:
      @"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",
      (int)self.networkDetailWebView.frame.size.width]];
    [self.networkDetailWebView scalesPageToFit];
    [self reloadHtml]; // --> reload the contents
    [self.stackImage setFrame:CGRectMake(398, 81, 375, 245)];
    [self.productPhoto setFrame:CGRectMake(390, 370, 375, 188)];
    [self.resourcesWebView setFrame:CGRectMake(370, 735, 411, 200)];
    // reset the background
    [self.backgroundNetworkDetailLandscape setHidden:YES];
    [self.networkDetailWebView setOpaque:NO];
    [self.networkDetailWebView setBackgroundColor:[UIColor clearColor]];
    // instead of adding this to networkDetailWebView, add it to self.view and put it behind
    // then you can remove/place when you switch to landscape
    [self.backgroundNetworkDetailPortrait setFrame:CGRectMake(5, 80, 363, 785)];
    [self.backgroundNetworkDetailPortrait setHidden:NO];
    [self.view addSubview:self.backgroundNetworkDetailPortrait];
    [self.view sendSubviewToBack:self.backgroundNetworkDetailPortrait];          //move the background view to the back of UIWebView
//    [self.networkDetailWebView reload]; // --> reload the contents
}

-(void)reconfigureLandscape{
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    CGPoint portraitCenter = CGPointMake(512, 400);
    [self.view setCenter:portraitCenter];
    [self.networkDetailWebView setFrame:CGRectMake(0, 50, 460, 610)];
    [self.stackImage setFrame:CGRectMake(548, 20, 375, 245)];
    [self.productPhoto setFrame:CGRectMake(548, 283, 375, 188)];
    [self.resourcesWebView setFrame:CGRectMake(460, 530, 563, 196)];
    [self.backgroundNetworkDetailPortrait setHidden:YES];
    [self.networkDetailWebView setOpaque:NO];
    [self.networkDetailWebView setBackgroundColor:[UIColor clearColor]];
    [self.backgroundNetworkDetailLandscape setFrame:CGRectMake(0, 50, 460, 610)];
    [self.backgroundNetworkDetailLandscape setHidden:NO];
    [self.view addSubview:self.backgroundNetworkDetailLandscape];
    [self.view sendSubviewToBack:self.backgroundNetworkDetailLandscape];          //move the background view to the back of UIWebView
}

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self setProductImageName: nil];
//        [self configureView];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [self.view setFrame:CGRectMake(0, 0, 760, 1024)];
    [self configureView];
}

- (void)viewDidLoad {
    // [self configureView];
    [super viewDidLoad];
    // use the main vc to go home
    if (!self.mainViewController) {
        self.mainViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    }
//  backgrounds
    self.backgroundNetworkDetailPortrait = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"networkDetail_left_panel_portrait.png"]]; // background
    
    self.backgroundNetworkDetailLandscape = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"networkDetail_left_panel.png"]]; //init a background
   
    
    // set up the network to which the BACK button will go
    // this is inside of scroll view, how do you do this???
    // a method connected to ViewController
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
//    NSLog(@"viewWillDisappear");
    // clear out subviews so they don't stack images
//    for (UIView *view in [self.networkDetailWebView subviews]) {
//        [view removeFromSuperview];
//    }
    for (UIImageView *view in [self.productPhoto subviews]) {
         [view removeFromSuperview];
    }
    for (UIImageView *view in [self.stackImage subviews]) {
        [view removeFromSuperview];
    }
    
}

- (void)viewDidUnload {
    [self setResourcesWebView:nil];
    [self setMainViewController:nil];
    [self setAppDelegate:nil];
    [self setProductPhoto:nil];
    [self setProductImageName: nil];
    [self setResourcesYUP:0];
    [self setResourcesYDown:0];
    [self setResourcesWebFrameY:0];
    [self setNetworkDetailWebView:nil];
    [self setBackButton:nil];
    [self setStackImage:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // if we are not re-doing views, this is how you should return this method
    // return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    
    if(interfaceOrientation == UIInterfaceOrientationPortrait) {
        //        NSLog(@"ims portrait - move legend down");
        [self reconfigurePortrait];
    }
    
    // if landscape, move back up
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        //        NSLog(@"ims landscape - move legend up");
        [self reconfigureLandscape];
    }
    
	return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (IBAction)showResourcesWebView:(id)sender {
    // new to use the _resourcesWebView because this is the pointer to the synthesized var
    CGRect theFrame = self.resourcesWebView.frame;// extract frame
    
    // set up the X button image for closing; we will re-use the legend close button for this
    UIImage *legendCloseImage = [UIImage imageNamed:@"Legend_btn_Close.png"];
    
    // going to have to calculate some values depending on how many bullet points we have for each !! IMPORTANT
    // 500 is up so, animate view down;
    if (theFrame.origin.y == resourcesWebFrameY) {
        // make the Y based on how much content
        //        float resourcesY = 610.0;
        
        theFrame.origin = CGPointMake(48.0, resourcesYUP); // set this back to it's original positions
        // animate by initing UIView settings
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.6];
        self.resourcesWebView.alpha = 1;
        self.resourcesWebView.frame = theFrame; // reset the frame
        [UIView commitAnimations]; // commit these animations to the frame; make it work!
        // going down so, remove the X button
        [resourcesButton setImage:nil forState:UIControlStateNormal];
    } else {
        //        float resourcesY = 500.0;
        theFrame.origin = CGPointMake(48.0, resourcesYDown);
        // animate by initing UIView settings
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.6];
        self.resourcesWebView.alpha = .9;
        self.resourcesWebView.frame = theFrame; // reset the frame
        [UIView commitAnimations]; // commit these animations to the frame
        // add the X image to close after the resources view has animated up
        [resourcesButton setImage:legendCloseImage forState:UIControlStateNormal];
    }
}


/*
 // for the top buttons: About, Contact, Order Poster, Questions
 // use the main vc for all these funtions
 -(IBAction)getInfo:(UIButton *)sender {
 // have to set the detail item of the infoViewController in order to pass along the currentTitle
 // infoViewController will load the infoWebView based on the currentTitle and display HTML
 // load in infoViewController view and fill it with values :: only one line so no {}
 if (!self.infoViewController) 
 self.infoViewController = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
 
 // set up the new detail item of the info view controller. this is what gives it the signal to do something 
 [self.infoViewController setDetailItem:sender.currentTitle];
 // now animate it on
 self.infoViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
 [self presentModalViewController:self.infoViewController animated:YES];
 
 // use the main vc for all these funtions - DOES NOT WORK - WHY?????
 // this will go all the way into infoViewController viewDidLoad but, it won't show anything
 // [mainViewController getInfo:sender];
 }
 
 // the top HOME button was clicked so, go to main page
 -(IBAction)goHome:(id)sender {
 // use the main vc to go home
 self.mainViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
 [self presentModalViewController:self.mainViewController animated:YES];
 
 // i keep this in to make sure the viewController is removed from the stack because I am using the code above to 
 // animate the transition home
 // use this if coming from presentModalViewController
 [self dismissModalViewControllerAnimated:YES];
 // use this if coming from addSubView
 // [self.view removeFromSuperview];
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
 
 
 
 // testing values
 - (IBAction)showButtonDetail:(UIButton *)sender {
 int buttonTag = [(UIButton*) sender tag];
 NSLog(@"title of button: %@",sender.currentTitle); // this will be the abbv
 NSLog(@"tag: %d", buttonTag); // this will be the index to the letters array so we know which file to open
 }
 */

@end
