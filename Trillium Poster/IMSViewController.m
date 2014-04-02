// IMSViewController.m - Trillium Poster
/*
 
 */

#import "IMSViewController.h"
//#import "AppDelegate.h"

// #import "TransitionController.h"// not sure about TransitionController just yet

@implementation IMSViewController
//@synthesize appDelegate;
//@synthesize legendButton;
//@synthesize legendImageView = _legendImageView;
@synthesize lteButton;

// for the blue navigation buttons to other networks
-(IBAction)openNetworkView:(UIButton *)sender {
    [self.view removeFromSuperview];
    // NOTIFICATION - NOTIFICATION_BACK_BUTTON is set up in the Trillium-Prefix.pch file
    // set up our arrays for title, tag combintations for the notification dictionary
    // need to be the same number and match
    
    NSArray *values = [NSArray arrayWithObjects:((UIButton *)sender.currentTitle), [NSNumber numberWithInteger:sender.tag], nil];
    NSArray *keys = [NSArray arrayWithObjects:@"title", @"tag", nil];
    // load up the dictionary with these two arrays
    NSDictionary *notificationInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    // you can now set up a listener for NOTIFICATION_BACK_BUTTON in any view controller > viewDidLoad
    // object in the call below could be ANY OBJECT, in this case, it is a dicitonary
    NSNotification *notification = [NSNotification notificationWithName:NOTIFICATION_OPEN_NETWORK_VIEW object:notificationInfo];
    // posts the notification to the defaultCenter
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (IBAction)openNetworkDetail:(UIButton *)sender {
    // NSLog(@"MainViewController openNetworkView: removed? go to appD openVC");
    [self.view removeFromSuperview]; // get rid of this view and open the network view
//    NSLog(@"ONW: title: %@ tag: %d", sender.currentTitle, sender.tag);    
    // set up our arrays for title, tag combintations for the notification dictionary
    // need to be the same number and match
    NSArray *values = [NSArray arrayWithObjects:((UIButton *)sender.currentTitle), [NSNumber numberWithInteger:sender.tag], nil];
    NSArray *keys = [NSArray arrayWithObjects:@"title", @"tag", nil];
    // load up the dictionary with these two arrays
    NSDictionary *notificationInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    // set up a notification naming it from the prefix file with NOTIFICATION_NETWORK_DETAIL_SHOULD_OPEN == networkDetailShouldOpen
    // you can now set up a listener for NOTIFICATION_NETWORK_DETAIL_SHOULD_OPEN in any view controller 
    // object in the call below could be ANY OBJECT, in this case, it is a dicitonary
    NSNotification *notification = [NSNotification notificationWithName:NOTIFICATION_NETWORK_DETAIL_SHOULD_OPEN object:notificationInfo];
    // posts the notification to the defaultCenter
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
/*
- (IBAction)showLegend:(id)sender {
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
*/




/*
- (IBAction)openLTE:(UIButton *)sender {
    // use the button on the bottom of the screen to open the LTE network
    
    // TRANSITION VIEW CONTROLLER WAY
  
     AppDelegate *appD = [UIApplication sharedApplication].delegate;
     // http://stackoverflow.com/questions/8146253/animate-change-of-view-controllers-without-using-navigation-controller-stack-su
     // use the imported TransitionController class to make the animation
     transitionController = [[TransitionController alloc] initWithViewController:lteViewController];
     [appD.window setRootViewController:transitionController];
     [self.transitionController transitionToViewController:lteViewController withOptions:UIViewAnimationOptionTransitionFlipFromBottom];
     
    // standard xcode open 
    // self.lteViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve; 
    // [self presentModalViewController:self.lteViewController animated:YES];
}
 
 
 // for the top buttons: About, Contact, Order Poster, Questions
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
    
    
    //  self.mainViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //  [self presentModalViewController:self.mainViewController animated:YES];
    
    // i keep this in to make sure the viewController is removed from the stack because I am using the code above to 
    //     animate the transition home
    // use this if coming from presentModalViewController
    [self dismissModalViewControllerAnimated:YES];
	// use this if coming from addSubView
    // [self.view removeFromSuperview];
} 
 */

#pragma mark - View lifecycle

-(void)reconfigurePortrait {
    [self.view setFrame:CGRectMake(0, 0, 940, 1180)];
    CGPoint portraitCenter = CGPointMake(362, 560);
    [self.view setCenter:portraitCenter];

}

-(void)reconfigureLandscape {
    [self.view setFrame:CGRectMake(0, 0, 1080, 860)];
    CGPoint portraitCenter = CGPointMake(512, 400);
    [self.view setCenter:portraitCenter];

}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setLteButton:nil];
    [super viewDidUnload];
}

-(void) viewWillAppear:(BOOL)animated {
    //  kick off the notification to show the legend for this network view
    // set up our arrays for title, tag combintations for the notification dictionary
    // need to be the same number and match
    NSArray *values = [NSArray arrayWithObjects:@"YES", nil];
    NSArray *keys = [NSArray arrayWithObjects:@"toShow", nil];
    // load up the dictionary with these two arrays
    NSDictionary *notificationInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    // set up a notification naming it from the prefix file with NOTIFICATION_NETWORK_DETAIL_SHOULD_OPEN == networkDetailShouldOpen
    // you can now set up a listener for NOTIFICATION_NETWORK_DETAIL_SHOULD_OPEN in any view controller 
    // object in the call below could be ANY OBJECT, in this case, it is a dicitonary
    NSNotification *notification = [NSNotification notificationWithName:NOTIFICATION_NETWORK_SHOW_LEGEND object:notificationInfo];
    // posts the notification to the defaultCenter
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


-(void)viewWillDisappear:(BOOL)animated {
    //  kick off the notification to show the legend for this network view
    // set up our arrays for title, tag combintations for the notification dictionary
    // need to be the same number and match
    NSArray *values = [NSArray arrayWithObjects:@"NO", nil];
    NSArray *keys = [NSArray arrayWithObjects:@"toShow", nil];
    // load up the dictionary with these two arrays
    NSDictionary *notificationInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    // set up a notification naming it from the prefix file with NOTIFICATION_NETWORK_DETAIL_SHOULD_OPEN == networkDetailShouldOpen
    // you can now set up a listener for NOTIFICATION_NETWORK_DETAIL_SHOULD_OPEN in any view controller 
    // object in the call below could be ANY OBJECT, in this case, it is a dicitonary
    NSNotification *notification = [NSNotification notificationWithName:NOTIFICATION_NETWORK_SHOW_LEGEND object:notificationInfo];
    // posts the notification to the defaultCenter
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}

// we are loading this .xib into a scroll view and in order for the first time load to work, this has to be here
// even though we are calling these two from the ViewController didRotateFromInterfaceOrientation
// we don't need didRotateFromInterfaceOrientation in this because that is controlled from ViewController
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


@end
