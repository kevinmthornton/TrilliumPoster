// ViewController.m - NavigationScroll
/*
 Videos - the mainScrollView will be hidden and three new views will be drawn
 HAVE to make mainScrollView setHidden:NO
 HAVE to clear out the three video views, setting them to hidden or nil
 
 */

#import "ViewController.h"
#import "AppDelegate.h"
#import "NavWebView.h"
#import "MainViewController.h" // first screen
#import "NetworkDetailViewController.h"

// all the network views
#import "IMSViewController.h"  
#import "LTEViewController.h"
#import "SmallCellViewController.h"
#import "WCDMAViewController.h"

@implementation ViewController
@synthesize buttonTitle;
@synthesize navController = _navController;
@synthesize mainScrollView = _mainScrollView;
@synthesize infoWebView = _infoWebView;
@synthesize intelButton;

@synthesize appDelegate;
@synthesize navWebView = _navWebView;
@synthesize mainViewController = _mainViewController;
@synthesize networkDetailViewController = _networkDetailViewController;
@synthesize imsViewController = _imsViewController;
@synthesize lteViewController = _lteViewController;
@synthesize smallCellViewController = _smallCellViewController;
@synthesize wcdmaViewController = _wcdmaViewController;
@synthesize legendImageView = _legendImageView;
@synthesize legendButton = _legendButton;

// all the video vars
@synthesize videosUrl;
@synthesize videoDictionary;
@synthesize categoryNames;
@synthesize videoWebView;
@synthesize videoBackgroundView;
@synthesize thumbNailScrollView;
@synthesize buttonScrollView, rightCap, leftArrowView, rightArrowView, leftArrowButton, rightArrowButton;

@synthesize screenWidth, startX;

#pragma mark - video methods

// from button at the top, open all the necessary views for the video section
- (IBAction)openVideo:(UIButton *)sender {
    // we need a connection for this page so, show this message
    if (![self connectedToInternet]) {
        // NSLog(@"yes, we have an internet connection");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection" message:@"You do not have an internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
//        return NO;
    }
    // hide all the views, set video views to nil to start  
    [self hideAllViews];
    [self setVideoWebView:nil];
    [self setVideoBackgroundView:nil];
    [self setThumbNailScrollView:nil];
    [self setButtonTitle:nil];
    
    // add a web and two scroll views the screen, checking landscape or portrait
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        self.videoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(20.0f, 100.0f, 650.0f, 405.0f)];
        self.videoBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(20.0f, 100.0f, 715.0f, 474.0f)];
        self.thumbNailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 824.0f, 768.0f, 130.0f)];
        self.buttonScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 954.0f, 768.0f, 50.0f)];
    } else {
        self.videoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(155.0f, 80.0f, 650.0f, 405.0f)];
        self.videoBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(140.0f, 65.0f, 715.0f, 474.0f)];
        self.thumbNailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 560.0f, 1024.0f, 130.0f)];
        self.buttonScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 695.0f, 1024.0f, 50.0f)];
    }
    
    [self.thumbNailScrollView setDelegate:self];
     
    // set up the background images in the views
    UIImage *videoBackground = [UIImage imageNamed:@"VideoPlayer-DropShadow.png"];
    [self.videoBackgroundView setBackgroundColor:[UIColor colorWithPatternImage:videoBackground]];
    
    UIImage *thumbNailBackground = [UIImage imageNamed:@"Thumbnail-Tray.png"];
    [self.thumbNailScrollView setBackgroundColor:[UIColor colorWithPatternImage:thumbNailBackground]];
    
    // move to back? - code below the addSubView
    UIImage *buttonBackground = [UIImage imageNamed:@"Category-Button-Tray.png"];
    [self.buttonScrollView setBackgroundColor:[UIColor colorWithPatternImage:buttonBackground]];
    
    // videosUrl = [[NSBundle mainBundle] URLForResource:@"Videos" withExtension:@"xml"]; // local file
    videosUrl = [NSURL URLWithString:@"http://www.radisys.com/trillium-poster/videos/Videos.xml"];// web file
    // set up the dictionary
    videoDictionary = [[NSDictionary alloc ] initWithContentsOfURL:videosUrl];
    // get all the keys for the category buttons - these will be the button titles
//    categoryNames = [videoDictionary keysSortedByValueUsingSelector:@selector(compare:)];
    categoryNames =  [[videoDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    // set up the thumbNailScrollView size for scrolling
    [self.thumbNailScrollView setScrollEnabled:YES];
    // CALCULATE this based on the number of thumbnails?
    [self.thumbNailScrollView setContentSize:CGSizeMake(1200.0f, 100.0f)];
    
    // set up the buttonScrollView size for scrolling
    [self.buttonScrollView setScrollEnabled:YES];
    // CALCULATE this based on the number of thumbnails?
    [self.buttonScrollView setContentSize:CGSizeMake(1000.0f, 50.0f)];
    [self.buttonScrollView setContentInset:UIEdgeInsetsMake(0, 150, 0, 0)];
    
    // set up the first x and y for the buttons
    // how about  these???? - character width of each title in the XML file?
    // CENTERING - if buttonWidth is 105, count the number of categories(categoryNames), multiply by 105, 
    // subtract out the screen width(screenWidth) depending on oreientation divide by 2 and that is where you start
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        screenWidth = 760;
    } else {
        screenWidth = 1024;
    }
    
    NSInteger categoryCount = [categoryNames count];
    // which is greater? so we do the subtraction correctly
    if (categoryCount > screenWidth) {
        startX = ((categoryCount * 117) - screenWidth)/2;
    } else {
        startX = (screenWidth - (categoryCount * 117))/2;
    }
    
    // BUTTONS for category list
    // set up the left cap: Category-Button-Cap-Left.png
    UIImageView *leftCap = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Category-Button-Cap-Left.png"]];
    [leftCap setFrame:CGRectMake(startX, 10, 13, 25)];
    [self.buttonScrollView addSubview:leftCap];
    
    startX += 13;   // have to account for the width of the leftCap
    float startY = 10.;
    float buttonWidth = 105.;
    float buttonHeight = 25.;
    
    // load up the category buttons into the buttonScrollView
    // these are all the categories from the XML
    for (NSString *categoryName in categoryNames) {
        // create the button and add it to buttonScrollView
        // place the button on the view next to each other
        UIButton *connectionButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        [connectionButton setBackgroundImage:[UIImage imageNamed:@"Category-Button-BG.png"] forState:UIControlStateNormal];
        [connectionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        connectionButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        // set up the frame placement and the size
        // variable button width based on categoryName? --> which is what is displayed
        connectionButton.frame = CGRectMake(startX, startY, buttonWidth, buttonHeight);
        
        // i want to chop off the first 2 characters, 1-, 2-
//        NSString *subCategoryName = [categoryName substringFromIndex:2];
        
        // set up the title for the button
        [connectionButton setTitle:categoryName forState:UIControlStateNormal];
        
        // assign this button a method for when pressed
        [connectionButton addTarget:self action:@selector(loadThumbNails:) forControlEvents:UIControlEventTouchUpInside];
        
        // add this to buttonScrollView
        [self.buttonScrollView addSubview:connectionButton];
        
        // increment X so that the buttons stack next to each other
        // have to play with font size of buttons to get all these on screen
        startX += 106.;
        
        //now put in the left button 
        UIImageView *buttonDiv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Category-Button-Cap-Left.png"]];
        [buttonDiv setFrame:CGRectMake(startX, startY, 1, 25)];
        [self.buttonScrollView addSubview:buttonDiv];
        
    }
    
    // set up the right cap: Category-Button-Cap-Right.png
    rightCap = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Category-Button-Cap-Right.png"]];
    [rightCap setFrame:CGRectMake(startX, 10, 13, 25)];
    [self.buttonScrollView addSubview:rightCap];
    
//  first try for loading the video  
//	NSURL *siteURL = [[NSURL alloc] initWithString:@"http://www.youtube.com/embed/t8yfWwSGkO8"];
//	NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:siteURL];
//	[self.videoWebView loadRequest:urlRequest];
    
//  load up the videoWebView with the first video in the featured section
    NSArray *featuredArray = [videoDictionary valueForKey:@"Featured"];
    NSDictionary *firstFeaturedDict = [featuredArray objectAtIndex:0];
    NSString *firstFeaturedVideo = [firstFeaturedDict objectForKey:@"Video"];
    UIButton *firstFeaturedButton = [[UIButton alloc] init];
    // make a button so that we can just pass this to loadVideo
    [firstFeaturedButton setTitle:firstFeaturedVideo forState:UIControlStateNormal];
    [self loadVideo:firstFeaturedButton];
    
//  load up the thumbnails from featured so it is the first to display
    UIButton *firstFeaturedThumbButton = [[UIButton alloc] init];
    // make a button so that we can just pass this to loadThumbNails
    [firstFeaturedThumbButton setTitle:@"ATCA" forState:UIControlStateNormal];
    [self loadThumbNails:firstFeaturedThumbButton];
    
    
    // add all the video views
    [self.view addSubview:self.thumbNailScrollView];
    [self.view addSubview:self.buttonScrollView]; 
    [self.view sendSubviewToBack:self.buttonScrollView]; // this was covering the Intel logo so, send to back 
    [self.view addSubview:self.videoBackgroundView];
    [self.view addSubview:self.videoWebView];
    
//  ORDER MATTERS!!! if you put this on the screen first, it gets covered up by the thumbNailScrollView
//  if you add this after, it goes on top!
//  create a simple view and then add the leftArrow Button to it
    self.leftArrowView = [[UIView alloc] init];
    [self.leftArrowView setUserInteractionEnabled:YES];
    self.leftArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftArrowButton setBackgroundImage:[UIImage imageNamed:@"Thumbnail-NavArrow-Left.png"] forState:UIControlStateNormal];
    [self.leftArrowButton setTitle:@"left" forState:UIControlStateNormal]; // which direction?
    [self.leftArrowButton setFrame:CGRectMake(0, 0, 23, 23)];
    // assign this button a method for when pressed
    [self.leftArrowButton addTarget:self action:@selector(scrollThumbNails:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftArrowView addSubview:leftArrowButton];
    
    // now do the right thumbnail button
    self.rightArrowView = [[UIView alloc] init];
    [self.rightArrowView setUserInteractionEnabled:YES];
    self.rightArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightArrowButton setBackgroundImage:[UIImage imageNamed:@"Thumbnail-NavArrow-Right.png"] forState:UIControlStateNormal];
    [self.rightArrowButton setTitle:@"right" forState:UIControlStateNormal]; // which direction?
    [self.rightArrowButton setFrame:CGRectMake(0, 0, 23, 23)];
    // assign this button a method for when pressed
    [self.rightArrowButton addTarget:self action:@selector(scrollThumbNails:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightArrowView addSubview:rightArrowButton];
    
    // now do all the placement of the left/right arrows
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        [leftArrowView setFrame:CGRectMake(5, 871, 23, 23)];
        [rightArrowView setFrame:CGRectMake(742, 871, 23, 23)];
    } else {
        [leftArrowView setFrame:CGRectMake(5, 605, 23, 23)];
        [rightArrowView setFrame:CGRectMake(995, 605, 23, 23)];
    }
    
    [self.view addSubview:leftArrowView];
    [self.view bringSubviewToFront: leftArrowView];
    [self.view addSubview:rightArrowView];
    [self.view bringSubviewToFront: rightArrowView];
    
    
}

// click on one of the thumbnails and pass in the button 
// grab button title and load up that video from the XML
-(void)loadVideo:(UIButton *)videoName {
//  NSLog(@"videoName: %@", videoName.currentTitle);
//  load up the videoWebView with the passed video name, these are mp4's that are stored on our server
//  NSString *videoURL = [[NSString alloc] initWithFormat:@"http://64.49.225.187/trillium-poster/videos/%@",videoName.currentTitle];
//  these are the video's from youtube. you will pass them around by there youtube.com id
    NSString *videoURL = [[NSString alloc] initWithFormat:@"http://www.youtube.com/embed/%@",videoName.currentTitle];
	NSURL *siteURL = [[NSURL alloc] initWithString:videoURL];
	NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:siteURL];
	[self.videoWebView loadRequest:urlRequest];
    
}

// pass in the button name and grab it's title
// open XML file ad get a list of thumbnails to display in thumbNailScrollView
- (IBAction)loadThumbNails:(UIButton *)sender {
//  first clear out the thumbnailScrollView
    for (UIView *view in [self.thumbNailScrollView subviews]) {
        [view removeFromSuperview];
    }
    // the sender.currentTitle will get you the key to the array of thumbnails
    NSString *categoryName = sender.currentTitle;
    // get the array of thumbnail information
    NSArray *thumbNailArray = [videoDictionary valueForKey:categoryName];
    // NSLog(@"thumbNailArray: %@", thumbNailArray);
        
    // set up the first x and y for the buttons
    // startX is an instance var to be controlled in other places
    startX = 32.0f;
    float startY = 8.0f;
    float buttonWidth = 135.0f;
    float buttonHeight = 75.0f;
    
    // do these for the label
    float startXLabel = 32.0f;
    float startYLabel = 79.0f;
    float labelWidth = 135.0f;
    float labelHeight = 80.0f;
    
    // iterate through the array and add these to the thumbNailScrollView with some space
    for (NSDictionary *thumbNailDictionary in thumbNailArray) {
        // assign this to the label under the button
        NSString *thumbTitle = [thumbNailDictionary objectForKey:@"Title"];
        // assign this as the button image
        NSString *thumbImageName = [thumbNailDictionary objectForKey:@"Thumbnail"];
        
        // get image data FROM WEB SITE
        // create string for the images name
        NSString *thumbImageString = [[NSString alloc] initWithFormat:@"http://www.radisys.com/trillium-poster/videos/%@",thumbImageName];
        // create the URL for the thumbnail
        NSURL *thumbImageURL = [NSURL URLWithString:thumbImageString];
        // grab the data
        NSData *thumbImageData = [NSData dataWithContentsOfURL:thumbImageURL];
        // local file
        // UIImage *thumbImage = [UIImage imageNamed:thumbImageName];
        UIImage *thumbImage = [UIImage imageWithData:thumbImageData];
        
        // assign this as the buttons title so we can pass into the loadVideo
        NSString *thumbVideo = [thumbNailDictionary objectForKey:@"Video"];
        
        // create the button and add it to buttonScrollView
        // place the button on the view on top of each other
        UIButton *thumbButton =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
        // set up the frame placement and the size
        thumbButton.frame = CGRectMake(startX, startY, buttonWidth, buttonHeight);
        // set up the title for the button
        [thumbButton setTitle:thumbVideo forState:UIControlStateNormal];
        [thumbButton setImage:thumbImage forState:UIControlStateNormal];
        // assign this button a method for when pressed
        [thumbButton addTarget:self action:@selector(loadVideo:) forControlEvents:UIControlEventTouchUpInside];
        [self.thumbNailScrollView addSubview:thumbButton];
        
         // now do the label as a UITEXTVIEW because the alignment can't be to the top
        UITextView *thumbLabel = [[UITextView alloc] initWithFrame:CGRectMake(startXLabel, startYLabel, labelWidth, labelHeight)];
        [thumbLabel setUserInteractionEnabled:NO];
        [thumbLabel setScrollsToTop:NO];
        [thumbLabel setContentInset:UIEdgeInsetsMake(-8,0,0,0)];
        [thumbLabel setFont:[UIFont fontWithName:@"Helvetica"size:13]];
//      [thumbLabel setNumberOfLines:0];
//        [thumbLabel setBackgroundColor:[UIColor yellowColor]];
        [thumbLabel setTextAlignment:UITextAlignmentCenter];
        [thumbLabel setText:thumbTitle];
        [thumbLabel setTextColor:[UIColor blackColor]];
        // add this to buttonScrollView
        [self.thumbNailScrollView addSubview:thumbLabel];
        
        // increment X so that the buttons stack next to each other
        // have to play with font size of buttons to get all these on screen
        startX += 205.;
        startXLabel += 205.;
    }
}

// this is for the two buttons to the left/right of the video thumbnails. when tapped, i want them to scroll the 
// thumbNailView one section to the right or left depending
-(void)scrollThumbNails:(UIButton *)direction{
    NSString *whichDirection = direction.currentTitle;
    CGPoint thumbNailOffSet = self.thumbNailScrollView.contentOffset;
    // if left and portrait
    if ([whichDirection isEqualToString:@"left"] && UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        thumbNailOffSet.x -= 600;
    } else if([whichDirection isEqualToString:@"left"] && !UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        thumbNailOffSet.x -= 850;
    } else if([whichDirection isEqualToString:@"right"] && UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        thumbNailOffSet.x += 600;
    } else if([whichDirection isEqualToString:@"right"] && !UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        thumbNailOffSet.x += 850;
    }

    [self.thumbNailScrollView setContentOffset:thumbNailOffSet animated:YES];
}

#pragma mark - nav methods

// hide all the views in the center of the screen and show only the ones you want with that particilar method
-(void)hideAllViews {
    // hide the main view
    [self.mainScrollView setHidden:YES];
    
    // hide all the video views 
    [self.videoBackgroundView setHidden:YES];
    [self.videoWebView setHidden:YES];
    [self.thumbNailScrollView setHidden:YES];
    [self.buttonScrollView setHidden:YES];
    [self.legendButton setHidden:YES];
    [self.legendImageView setHidden:YES];
    [self.leftArrowView setHidden:YES];
    [self.rightArrowView setHidden:YES];
    
    // hide the info view
    [self.infoWebView setHidden:YES];
}

// this is just for the top HOME button to load up main screen
- (IBAction)openMain {
    // hide all the other views
    [self hideAllViews];
    
    // clear out all the views in mainScrollView
    [self clearMainScrollView];
    [self.mainScrollView setZoomScale:1.00];
    [self.mainScrollView setContentOffset:CGPointZero];
//    [self.mainScrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    //    reset the zoom so that they all go back to 1 when clicked on
    CGAffineTransform resetTransform = CGAffineTransformMakeScale(1.0, 1.0);
    self.mainViewController.view.transform = resetTransform;
    //    now put this in the upper left corner each time
    [self.mainViewController.view setFrame:CGRectMake(0, 0, 1024, 768)];
    
    [self.mainScrollView setHidden:NO];
    [self.mainScrollView addSubview:self.mainViewController.view];
}

// from the other classes, they call notification center which just refers to this function passing on the notification object
-(IBAction)openNetworkView:(NSNotification *)notification {
    // this method will open whichever view was passed in
    [self hideAllViews];
    [self clearMainScrollView];
    
//  reset the scrolling in the main scroll view to be top right
    [self.mainScrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
//  reset the zoom so that they all go back to 1 when clicked on
    CGAffineTransform resetTransform = CGAffineTransformMakeScale(1.0, 1.0);
    self.imsViewController.view.transform = resetTransform;
    self.lteViewController.view.transform = resetTransform;
    self.smallCellViewController.view.transform = resetTransform;
    self.wcdmaViewController.view.transform = resetTransform;
    
//  now put this in the upper left corner each time
    [self.imsViewController.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.lteViewController.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.smallCellViewController.view setFrame:CGRectMake(0, 0, 1024, 768)];
    [self.wcdmaViewController.view setFrame:CGRectMake(0, 0, 1024, 768)];    
    
    // get the values from the notification dictionary that was passed
    // grab our info out of the notification.object which in this case is a dictionary
    NSDictionary *notificationInfo = (NSDictionary *)notification.object;
    buttonTitle = [notificationInfo objectForKey:@"title"];
    
    // the if gives you and eye to what you are going to but, not as effecient? oh, well
    if ([buttonTitle isEqualToString:@"IMS"]) {
        [self.mainScrollView addSubview:self.imsViewController.view];
    }
    
    if ([buttonTitle isEqualToString:@"LTE"]) {
        [self.mainScrollView addSubview:self.lteViewController.view];
    }
    
    // the if gives you and eye to what you are going to but, not as effecient? oh, well
    if ([buttonTitle isEqualToString:@"SmallCell"]) {
        [self.mainScrollView addSubview:self.smallCellViewController.view];
    }
    
    if ([buttonTitle isEqualToString:@"WCDMA"]) {
        [self.mainScrollView addSubview:self.wcdmaViewController.view];
    }
 }

// NOTIFICATION - this is the method assigned to open the network detial view based on a tap to an element
// it is called from one of the network view controllers(IMS, LTE...) in the openNetworkDetail method
// passing in a notification to this method from openNetworkDetail
// this is set up in viewDidLoad
-(IBAction)openNetworkDetailView:(NSNotification *)notification {
    // grab our info out of the notification.object which in this case is a dictionary
    NSDictionary *notificationInfo = (NSDictionary *)notification.object;
    int buttonTag = [[notificationInfo objectForKey:@"tag"] intValue];
//    NSLog(@"VC.oNDV: buttonTag: %i", buttonTag);
    
    // set the index to the buttonTag value which is an NSInteger
    [self.networkDetailViewController setFileIndex:buttonTag];
//    NSLog(@"C.oNDV fileIndex: %i", self.networkDetailViewController.fileIndex);
    
    // set up the new detail item of the detail view controller. this is what gives it the signal to do something
    NSString *currentTitle = [notificationInfo objectForKey:@"title"];
    // set up the abbreviation string
    [self.networkDetailViewController setAbbvString:currentTitle];
    [self.networkDetailViewController setDetailItem:currentTitle];
    // reset the scrollview back to the top
    [self.mainScrollView setContentOffset:CGPointZero];
    [self.mainScrollView setZoomScale:.99f];
    [self.mainScrollView addSubview:self.networkDetailViewController.view];
}


// clear out all the views in mainScrollView so you can load one
// this is so you don't get a huge stack of views inside mainScrollView
-(void)clearMainScrollView {
    for (UIView *view in [self.mainScrollView subviews]) {
        [view removeFromSuperview];
    }
    [self.mainScrollView setZoomScale:.99];
    [self.mainScrollView setHidden:NO];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {  
//    NSLog(@"made it into shouldStartLoadWithRequest");
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
        // this is for Contact Us. I don't want the #tab1 to go out to the nav controller; I want it to stay in this web view
        NSRange textRange;
        textRange =[[requestURL absoluteString] rangeOfString:@"#"];
        
        if(textRange.location != NSNotFound){
            return YES; // If it is HTTP or HTTPS, just return YES and the page loads.
        } else {
            // NOTIFICATION for opening a web link
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
        }
    } else { // from if navigationType 
        // default, just in case
        return YES;
    }
} 

// loads a nav controller over top of everything
-(void)openNavControllerLink:(NSNotification *)notification {
    
    // in NavWebView.m - must do all the work in viewWillAppear
    
    // NSLog(@"linktoopen: %@", linkToOpen);
    // from buttons up top for web links
    // set up a navWebView because that holds a web view that they will see this link load into 
    
    // get the values from the notification dictionary that was passed
    // grab our info out of the notification.object which in this case is a dictionary
    NSDictionary *notificationInfo = (NSDictionary *)notification.object;
//  format the URL into a string
    NSURL *linkToOpen =  [notificationInfo objectForKey:@"URL"];
    [self.navWebView setWebURL:linkToOpen];
    self.navWebView.navigationItem.title = @"Radisys.com";
    // no need to push the navWebView onto the navContoller, we did that when we alloc/init'd this
    [self presentModalViewController:self.navController animated:YES];
}

// do they have an internet connection?
- (BOOL) connectedToInternet {     
    NSError *urlError = [[NSError alloc] init];
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"] encoding:NSUTF8StringEncoding error:&urlError];
    return ( URLString != NULL ) ? YES : NO;
    
}

#pragma mark - info buttons

// !!!!!!!!!!!!!!!! do this to the VIDEO buttons; --> hide the left/right scroll buttons when the video thumnail view goes off screen
// HIDE ALL VIEWS !!!

//  this method will show the legend button and hidden legend image when a network is displayed using a notification
-(void)showLegendButton:(NSNotification *)notification {
    NSDictionary *notificationInfo = (NSDictionary *)notification.object;
    BOOL toShow =  [[notificationInfo objectForKey:@"toShow"] boolValue];
    if (toShow == YES) {
        // load up the legend button and image - this will come from a newwork view(IE: IMS) in viewWillAppear
        [self.legendButton setHidden:NO];
        [self.legendImageView setHidden:NO];
    } else {
        // hide the legend and image - this will come from a newwork view(IE: IMS) in viewWillAppear
        [self.legendButton setHidden:YES];
        [self.legendImageView setHidden:YES];
    }
}

-(IBAction)showLegend:(id)sender {
    // must have the legendImageView User Interaction Enabled checkbox checked!
    // get current alpha and hide/show based on value
    // add the X button for the legend close to be offset in the upper right corner
    UIButton *legendCloseButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    // add in the image
    UIImage *legendCloseButtonImage = [UIImage imageNamed:@"Legend_btn_Close.png"];
    [legendCloseButton setBackgroundImage:legendCloseButtonImage forState:UIControlStateNormal];
    
    // set up the frame placement and the size to be offset
    legendCloseButton.frame = CGRectMake(390, 3, 23, 23); // 
    // set up the method for moving this resources view up and down
    [legendCloseButton addTarget:self action:@selector(showLegend:) forControlEvents:UIControlEventTouchUpInside];
    [legendCloseButton setUserInteractionEnabled:YES];
    // put this on the resourcesWebView
    [self.legendImageView addSubview:legendCloseButton];
    // animate by initing UIView settings
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.6];
    // reset the alpha
    if (self.legendImageView.alpha == 1) {
        self.legendImageView.alpha = 0;
    } else {
        self.legendImageView.alpha = 1;
    }
    [UIView commitAnimations]; // commit these animations to the frame 
}


// CHANGE!! we hide the main scroll view and then create a web view and add content to it 
// adding in the navigation controller

// this is for the buttons along the top (About, Contact, Help...) that load in text
-(IBAction)getInfo:(UIButton *)sender {
    // hide all the views
    [self hideAllViews];
    // clear out mainScrollView - just for memory sake
    [self clearMainScrollView];
    
    // the infoWebView is set up in viewDidLoad
    // set up the info  web view
    
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        self.infoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(20.0f, 80.0f, 728.0f, 400.0f)];
    } else {
        self.infoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(20.0f, 80.0f, 984.0f, 400.0f)];
    }
    
    // set the delegation!! this must be here for shouldStartLoadWithRequest to work along with the UIWebViewDelegate in the .h file
    [self.infoWebView setDelegate:self];
    // now populate and show the infoWebView
    // set up the view with values from the Info.xml file based on which button was clicked
    self.infoWebView.dataDetectorTypes=UIDataDetectorTypeAddress;
    buttonTitle = [[NSString alloc] initWithFormat:@"%@", [sender.currentTitle description]];
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

    [self.infoWebView setHidden:NO];
    [self.view addSubview:self.infoWebView];
}

// open the links from the buttons for the nav top and bottom right
- (IBAction)openWebLink:(UIButton *)sender {
    NSURL *linkURL = [[NSURL alloc] init];
//    NSLog(@"title: %@", sender.currentTitle);
    if ([sender.currentTitle isEqualToString:@"Intel"]) {
        linkURL = [NSURL URLWithString: @"http://www.intel.com/design/network/ica/"];
    } else if ([sender.currentTitle isEqualToString:@"Trillium"]) {
        linkURL = [NSURL URLWithString: @"http://www.radisys.com/Products/Trillium.html"];
    } else {
        linkURL = [NSURL URLWithString: @"http://www.radisys.com/"];
    }
    
    // open this in safari
    // [[ UIApplication sharedApplication ] openURL: linkURL];
    
    // TODO!! - change to notification
    //send to appDelegate to open the nav controller with this link
    // [appDelegate openNavControllerLink:linkURL];
    // NOTIFICATION SET UP
    //      NOTIFICATION for opening a web link
    // NOTIFICATION - NOTIFICATION_OPEN_NETWORK_VIEW is set up in the Trillium-Prefix.pch file
    // set up our array for URL in the notification dictionary
    // need to be the same number and match
    NSArray *values = [NSArray arrayWithObjects:((NSURL *)linkURL), nil];
    NSArray *keys = [NSArray arrayWithObjects:@"URL", nil];
    // load up the dictionary with these two arrays
    NSDictionary *notificationInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    // you can now set up a listener for NOTIFICATION_BACK_BUTTON in any view controller > viewDidLoad
    // object in the call below could be ANY OBJECT, in this case, it is a dicitonary
    NSNotification *notification = [NSNotification notificationWithName:NOTIFICATION_OPEN_NAV_CONTROLLER_LINK object:notificationInfo];
    // posts the notification to the defaultCenter
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}


// NOT USED!  - this needs to go to openNetworkView


// NOTIFICATION from the networkDetailViewController back button
// load in the network passed via the notification to the mainScrollView
// I did not use openNetworkView for this because that would change that method - TODO!!! - update openNetworkView to a notification
-(void)backToNetwork:(NSNotification *)notification {
    [self hideAllViews];
    [self clearMainScrollView];
    
    // get the values from the notification dictionary that was passed
    // grab our info out of the notification.object which in this case is a dictionary
    NSDictionary *notificationInfo = (NSDictionary *)notification.object;
    buttonTitle = [notificationInfo objectForKey:@"title"];

    if ([buttonTitle isEqualToString:@"IMS"]) {
        [self.mainScrollView addSubview:self.imsViewController.view];
    }

    if ([buttonTitle isEqualToString:@"LTE"]) {
        [self.mainScrollView addSubview:self.lteViewController.view];
    }    
}

#pragma mark - portrait/landscape

-(void)reconfigurePortrait {
//    NSLog(@"VC portrait: recongifPortrait");
    [self.mainScrollView setScrollEnabled:YES]; // this is set in IB but, just to be sure
    // trick this into getting it to scroll right away by zooming at 99%
    [self.mainScrollView setZoomScale:.99];
//    frame size vs. content size?
    [self.mainScrollView setFrame:CGRectMake(0.0f, 58.0f, 768.0f, 1024.0f)];
    // set the scrolling around inside size
    [self.mainScrollView setContentSize:CGSizeMake(980.0f, 1024.0f)];

    // for portrait mode, move the content of mainScrollView over 160 points to center it better
//    [self.mainScrollView setContentOffset:CGPointMake(300, 0)];
//    [self.mainScrollView setContentInset:UIEdgeInsetsMake(0, -160, 0, 0)];
    // place the intel logo correctly
    [self.intelButton setFrame:CGRectMake(700.0f, 954.0f, 38.0f, 35.0f)];
    
    // this is for all the networks
    [self.imsViewController reconfigurePortrait];
    [self.lteViewController reconfigurePortrait];
    [self.smallCellViewController reconfigurePortrait];
    [self.wcdmaViewController reconfigurePortrait];
    [self.mainViewController reconfigurePortrait];
//  legend button for networks
    [self.legendButton setFrame:CGRectMake(525, 958, 170, 35)];
    [self.legendImageView setFrame:CGRectMake(350, 826, 414, 125)];

    // move around the NetworkDetailViewController Resouces(125), and Product Image(126) Views like above
    [self.networkDetailViewController reconfigurePortrait];
    
    // video page, have to move around the three video views
    [self.videoWebView setFrame:CGRectMake(20.0f, 100.0f, 650.0f, 405.0f)];
    [self.videoBackgroundView setFrame:CGRectMake(20.0f, 100.0f, 715.0f, 474.0f)];
    [self.thumbNailScrollView setFrame:CGRectMake(0.0f, 824.0f, 768.0f, 130.0f)];
    [self.buttonScrollView setFrame:CGRectMake(0.0f, 954.0f, 768.0f, 50.0f)];
    [leftArrowView setFrame:CGRectMake(5, 871, 23, 23)];
    [rightArrowView setFrame:CGRectMake(742, 871, 23, 23)];
    
    // info web view
    [self.infoWebView setFrame:CGRectMake(20.0f, 100.0f, 728.0f, 510.0f)];
//    NSLog(@"infoview frame: %f", self.infoWebView.frame.size.width);
}

-(void)reconfigureLandscape {
//    NSLog(@"VC portrait: recongifLandscape");
    [self.mainScrollView setScrollEnabled:YES]; // this is set in IB but, just to be sure
    // trick this into getting it to scroll right away by zooming at 99%
    [self.mainScrollView setZoomScale:.99];
    // for portrait mode, move this over 185 points to center it better
    [self.mainScrollView setFrame:CGRectMake(0.0f, 58.0f, 1024.0f, 768.0f)];
    [self.mainScrollView setContentSize:CGSizeMake(1024.0f, 768.0f)]; // same size as this does not need to move
    // this is for WITHIN the main scroll view
    [self.mainScrollView setContentOffset:CGPointMake(0, 0)];
    
    // place the intel logo correctly
    [self.intelButton setFrame:CGRectMake(940.0f, 699.0f, 38.0f, 35.0f)];

    // this is for all the networks
    [self.imsViewController reconfigureLandscape];
    [self.lteViewController reconfigureLandscape];
    [self.smallCellViewController reconfigureLandscape];
    [self.wcdmaViewController reconfigureLandscape];
    [self.mainViewController reconfigureLandscape];
    
//  for the legend buttons
    [self.legendButton setFrame:CGRectMake(760, 701, 170, 35)];
    [self.legendImageView setFrame:CGRectMake(600, 576, 414, 125)];
    // move around the NetworkDetailViewController Resouces(125), and Product Image(126) Views like above
    [self.networkDetailViewController reconfigureLandscape];
    
    // video section
    [self.videoWebView setFrame:CGRectMake(155.0f, 80.0f, 650.0f, 405.0f)];
    [self.videoBackgroundView setFrame:CGRectMake(140.0f, 65.0f, 715.0f, 474.0f)];
    [self.thumbNailScrollView setFrame:CGRectMake(0.0f, 560.0f, 1024.0f, 130.0f)];
    [self.buttonScrollView setFrame:CGRectMake(0.0f, 695.0f, 1024.0f, 50.0f)];
    [leftArrowView setFrame:CGRectMake(5, 605, 23, 23)];
    [rightArrowView setFrame:CGRectMake(995, 605, 23, 23)];
    // still need the right view
    
    // info web view
    [self.infoWebView setFrame:CGRectMake(20.0f, 90.0f, 984.0f, 510.0f)];
}

#pragma mark - View lifecycle

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // which view is in the scroll view? identify this with the tag
    // 111 is main
    // 222 is IMS
    // 333 is LTE
    // 444 is Small Cell
    // 555 is WCDMA
    // 888 is info from buttons up top --> TAKING THIS OUT so can replace
    // 999 is the network detail --> taken out with new portrait/landscape layout change
//    if ([self.mainScrollView viewWithTag:111]) {
//        return self.mainViewController.view;
//    } else
        
    if ([self.mainScrollView viewWithTag:222]) {
        return self.imsViewController.view;
    } else if ([self.mainScrollView viewWithTag:333]) {
        return self.lteViewController.view;
    } else if ([self.mainScrollView viewWithTag:444]) {
        return self.smallCellViewController.view;
    } else if ([self.mainScrollView viewWithTag:555]) {
        return self.wcdmaViewController.view;
    } 
//    taken out because of new layout
//    else if ([self.mainScrollView viewWithTag:999]) {
//        return self.networkDetailViewController.view;
//    }
    
    // don't do anything if you can't find the right view
	return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up our appDelegate var so we can reference the methods there
    appDelegate = [[UIApplication sharedApplication] delegate];
//    set up the info  web view
//    self.infoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(20.0f, 100.0f, 984.0f, 360.0f)];
    
	// set up MainVC
    if (!self.mainViewController) {
        self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    }
    
    // set up NetworkDetail's
    if (!self.networkDetailViewController) 
        self.networkDetailViewController = [[NetworkDetailViewController alloc] initWithNibName:@"NetworkDetailViewController" bundle:nil];

    // set up IMS
    if (!self.imsViewController) {
        self.imsViewController = [[IMSViewController alloc] initWithNibName:@"IMSViewController" bundle:nil];
    }
    
    // set up LTE
    if (!self.lteViewController) {
        self.lteViewController = [[LTEViewController alloc] initWithNibName:@"LTEViewController" bundle:nil];
    }

    // set up Small Cell
    if (!self.smallCellViewController) {
        self.smallCellViewController = [[SmallCellViewController alloc] initWithNibName:@"SmallCellViewController" bundle:nil];
    }
    
    // set up Small Cell
    if (!self.wcdmaViewController) {
        self.wcdmaViewController = [[WCDMAViewController alloc] initWithNibName:@"WCDMAViewController" bundle:nil];
    }
    
//  set up the legend button and the legendImage so that when the network views are shown, these are displayed via a notification
//  these get placed in reconfigurePortrait and reconfigureLandscape depending on which orientation we are in
    self.legendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//  attach the legend button to the showLegend method
    [self.legendButton addTarget:self action:@selector(showLegend:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *legendButtonImage = [UIImage imageNamed:@"Footer_btn_Legend.png"];
    [self.legendButton setBackgroundImage:legendButtonImage forState:UIControlStateNormal];

//  this did not work programatically. I had to place a UIImageView into the .xib and hook it up to legendImageView
//    self.legendImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Legend-PopUp.png"]];
    [self.legendImageView setImage: [UIImage imageNamed:@"Legend-PopUp.png"]];
        
    [self.legendButton setHidden:YES];
    [self.legendImageView setHidden:YES];
    [self.legendImageView setAlpha:0.00f];
    [self.view bringSubviewToFront:self.legendImageView];
    [self.view addSubview:self.legendButton];
    [self.view addSubview:self.legendImageView];
    
    // NOTIFICATION to open the network detail view instead of the appDelegate call
    // listen for NOTIFICATION_NETWORK_DETAIL_SHOULD_OPEN and assign it to the method openNetworkDetailView: 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLegendButton:) name:NOTIFICATION_NETWORK_SHOW_LEGEND object:nil];
    
    // set up the navigation controller WITH the root view controller set up once so we don't push it twice
    self.navWebView = [[NavWebView alloc] init];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.navWebView];

    // set vars and load up the mainScrollView 
	self.mainScrollView.maximumZoomScale = 2.0;
	self.mainScrollView.minimumZoomScale = 1.00;
	self.mainScrollView.clipsToBounds = YES;
	self.mainScrollView.delegate = self;
//    [self.mainScrollView setContentInset:UIEdgeInsetsMake(0, -200, 0, 0)];
    [self.mainScrollView addSubview:self.mainViewController.view];
    

    self.thumbNailScrollView.delegate = self;
    
    // NOTIFICATION to open the network detail view instead of the appDelegate call
    // listen for NOTIFICATION_NETWORK_DETAIL_SHOULD_OPEN and assign it to the method openNetworkDetailView: 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openNetworkDetailView:) name:NOTIFICATION_NETWORK_DETAIL_SHOULD_OPEN object:nil];
    
    // NOTIFICATION that the back button was tapped in networkDetailViewController
    // sends the button title to openNetworkView so you go back to the network from which you came 
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openNetworkView:) name:NOTIFICATION_OPEN_NETWORK_VIEW object:nil];
    
    // NOTIFICATION that the back button was tapped in networkDetailViewController
    // sends the button title to openNetworkView so you go back to the network from which you came 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openNavControllerLink:) name:NOTIFICATION_OPEN_NAV_CONTROLLER_LINK object:nil];
    
   
}

// more granular control
// comes after viewDidLoad
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // self.interfaceOrientation returns the current interface oreientation
//    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
//        NSLog(@"VC - veiwWillAppear - portrait");
    if([self interfaceOrientation] == UIInterfaceOrientationPortrait ||
	   [self interfaceOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
//        NSLog(@"VC - portrait");
        [self reconfigurePortrait];
    } else {
        [self reconfigureLandscape];
    }
    // set this to 0,0 at the top left corner
    [self.mainScrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}


// NEW
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // i DID rotate, now recongifure me
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if (!UIInterfaceOrientationIsPortrait(fromInterfaceOrientation)) {
//        NSLog(@"VC - didRotate - portrait");
        [self reconfigurePortrait];
    } else {
        [self reconfigureLandscape];
    }
    
}


// should just check for the correct oreientation and return only what you want
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // return everything BUT upside down
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    /*
    // off set the .xib files in self.mainScrollView based on portrait oreientation
    if(interfaceOrientation == UIInterfaceOrientationPortrait) {
        // NSLog(@"VC portrait: shouldAuto");
        
        return YES;
    } 
 
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        // NSLog(@"VC Left");
        // [self reconfigureLandscape];        
        return YES;
    } 
    
    if(interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        // NSLog(@"VC Right");
        // [self reconfigureLandscape];  
        return YES;
    } 
     if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
     return NO; // no upside down
     }
     
     return YES; // just to be sure
     // this will return YES for either landscape
   
     
     */
    
    
    
	// return ((interfaceOrientation | UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation | UIInterfaceOrientationLandscapeRight));
}

- (void)viewDidUnload {
    [self setButtonTitle:nil];
    [self setMainScrollView:nil];
    [self setImsViewController:nil];
    [self setLteViewController:nil];
    [self setSmallCellViewController:nil];
    [self setWcdmaViewController:nil];
    [self setMainViewController:nil];
    [self setVideoWebView:nil];
    [self setThumbNailScrollView:nil];
    [self setButtonScrollView:nil];
    
    // Stop listening for notifications until my view is reloaded (in viewDidLoad)
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self setIntelButton:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


@end
