// MainViewController.m - Trillium Poster
/*
 I use appDelegate to talk with the AppDelegate methods which in turn talk to ViewController
 ViewController houses the mainScrollView which loads everything
 
 */

#import "MainViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"

@implementation MainViewController
@synthesize appDelegate;
@synthesize viewController = _viewController;
@synthesize mainText = _mainText;
@synthesize helpView = _helpView;
@synthesize backgroundLines = _backgroundLines;
@synthesize imsButton = _imsButton;
@synthesize lteButton = _lteButton;
@synthesize lteAButton = _lteAButton;
@synthesize smallCellButton = _smallCellButton;
@synthesize wcdmaButton = _wcdmaButton;
@synthesize commNetworkTitleView = _commNetworkTitleView;


// large buttons are linked to this and get set up ; these are then put into notifications and sent off to the notification center
-(IBAction)openNetworkView:(UIButton *)sender {
    [self.view removeFromSuperview];
    // NOTIFICATION - NOTIFICATION_OPEN_NETWORK_VIEW is set up in the Trillium-Prefix.pch file
    // set up our arrays for title, tag combintations for the notification dictionary
    // need to be the same number and match
    NSArray *values = [NSArray arrayWithObjects:((UIButton *)sender.currentTitle), [NSNumber numberWithInteger:sender.tag], nil];
    NSArray *keys = [NSArray arrayWithObjects:@"title", @"tag", nil];
    // load up the dictionary with these two arrays
    NSDictionary *notificationInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    // you can now set up a listener for NOTIFICATION_OPEN_NETWORK_VIEW in any view controller > viewDidLoad
    // object in the call below could be ANY OBJECT, in this case, it is a dicitonary
    NSNotification *notification = [NSNotification notificationWithName:NOTIFICATION_OPEN_NETWORK_VIEW object:notificationInfo];
    // posts the notification to the defaultCenter
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(void)reconfigurePortrait {
//  current center is 512 so, set and reset that
//  NSLog(@"P: %f",self.view.center.y);
    [self.view setFrame:CGRectMake(0, 0, 768, 1024)];
    CGPoint portraitCenter = CGPointMake(230, 560);
    [self.view setCenter:portraitCenter];
    [self.backgroundLines setFrame:CGRectMake(0, 205, 1025, 220)];
    
//    NSLog(@"MVC - backgroundLines center y: %f", self.backgroundLines.center.y);
}

-(void)reconfigureLandscape {
//    NSLog(@"L: %f",self.view.center.y);
    [self.view setFrame:CGRectMake(0, 0, 1024, 768)];
    CGPoint portraitCenter = CGPointMake(512, 360);
    [self.view setCenter:portraitCenter];
    [self.backgroundLines setFrame:CGRectMake(0, 206, 1025, 220)];
//    [self.imsButton setFrame:CGRectMake(375, 169, 355, 139)];
}

-(void)viewWillAppear:(BOOL)animated {
    if([self interfaceOrientation] == UIInterfaceOrientationPortrait ||
	   [self interfaceOrientation] == UIInterfaceOrientationPortraitUpsideDown) {
//        NSLog(@"MVC - fire off portrait");
        [self reconfigurePortrait];
    } else {
        [self reconfigureLandscape];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // load up the top view controller
    if (!self.viewController) {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    }
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    // set up the main text on the landing page from the Info.xml file
    // open xml file and get data
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"Info" withExtension:@"xml"];
    // set up the dictionary
    NSDictionary *infoDictionary = [[NSDictionary alloc ] initWithContentsOfURL:fileUrl];
    // get the values from the abbvString in the letterDicitonary; this gives you all the values in one dicitonary that you can pull apart
    NSString *mainTextString = [[NSString alloc] initWithFormat:@"%@",[infoDictionary objectForKey:@"Main"]];
    [self.mainText setText:mainTextString] ; //]mainTextString];
    [self.mainText setNeedsDisplay];
    
    // set up the background
    self.backgroundLines = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background_NetworkPath.png"]];
    [self.view addSubview:self.backgroundLines];
    [self.view sendSubviewToBack:self.backgroundLines];
    
    // TESTING!!! -- uncomment these to reset the user defaults
    // NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // [userDefaults setBool:NO forKey:@"closeHelpViewPopUp"];
    // show the help view? 
    [self showHelpView];
}

// when the user opens the app for the first time, they will see a pop up
// they will click a button to close it and not see it agian
// when they click that button, showHelpViewPopUp will be set to NO
// in viewDidLoad, showHelpViewPopUp will be checked and if YES, it is shown; otherwise stays hidden
-(IBAction)showHelpView {
    // set up the user defaults so we can record that they have seen the first screen
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];    
    
    // to read the BOOL from user defaults; if this is the first time they have opened the app, the help view is shown
    // as soon as they click the button to close it, the userDefault is set to YES and it will not show again
    // i used the negation because if they are coming the first time, this is not set
    if (![userDefaults boolForKey:@"closeHelpViewPopUp"]) {
        
        // add the X button for the help close to be offset in the upper right corner
        UIButton *helpButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        // add in the image
        UIImage *helpCloseButton = [UIImage imageNamed:@"Legend_btn_Close.png"];
        [helpButton setBackgroundImage:helpCloseButton forState:UIControlStateNormal];
        
        // set up the frame placement and the size to be offset
        helpButton.frame = CGRectMake(390, 3, 23, 23); // 
        // set up the method for moving this resources view up and down
        [helpButton addTarget:self action:@selector(closeHelpView:) forControlEvents:UIControlEventTouchUpInside];
        [helpButton setUserInteractionEnabled:YES];
        
        // put this on the resourcesWebView
        [self.helpView addSubview:helpButton];
        [self.helpView setHidden:NO];
        /*
         THIS IS for programming, not using IB
        helpView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 500, 300)];
        // create the label for the text
        UILabel *helpLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 450, 100)];
        helpLabel.font =  [UIFont fontWithName:@"Arial-BoldMT" size:14];
        [helpLabel setNumberOfLines:3];
        [helpLabel setTextAlignment:UITextAlignmentLeft];
        [helpLabel setBackgroundColor:[UIColor grayColor]];
        helpLabel.text = @"This is an interactive poster, tap on any element to see it's definition.";
        // place the label on the view
        [helpView addSubview:helpLabel];
        
        // create the button to close the view
        // add the button for the resources up/down action
        UIButton *helpButton =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
        // set up the frame placement and the size
        helpButton.frame = CGRectMake(10, 220, 100, 25);
        helpButton.titleLabel.text = @"Close this window"; // set the text of the button
        // set up the method for moving this resources view up and down
        [helpButton addTarget:self action:@selector(closeHelpView:) forControlEvents:UIControlEventTouchUpInside];
        
        // place the button on the view
        [helpView addSubview:helpButton];
        
        // set up the shadow
        helpView.layer.masksToBounds = NO;
        helpView.layer.cornerRadius = 9; // if you like rounded corners
        helpView.layer.shadowOffset = CGSizeMake(10, 12);
        helpView.layer.shadowRadius = 4;
        helpView.layer.shadowOpacity = 0.5;
        
        // take off the hidden status
        [helpView setHidden:NO];
        [self.view addSubview:helpView];
         */
    }
}

// close the view
-(IBAction)closeHelpView:(UIButton *)sender {
    // set the user default to no so it won't show again
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"closeHelpViewPopUp"];
    // take off the hidden status
    [self.helpView setHidden:YES];
}

// no longer used. i take these out via a subviews for loop in AppDelegate
-(void)removeFromScrollView {
    // NSLog(@"2 - mainVC: removeFromScrollView");
    [self.view removeFromSuperview];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidUnload
{
    [self setMainText:nil];
    [self setHelpView:nil];
    [self setBackgroundLines:nil];
    [self setImsButton:nil];
    [self setLteButton:nil];
    [self setLteAButton:nil];
    [self setSmallCellButton:nil];
    [self setWcdmaButton:nil];
    [self setCommNetworkTitleView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
