// LTEViewController.m - Trillium Poster
/*
 
 */

//#import "AppDelegate.h"
#import "LTEViewController.h"

@implementation LTEViewController
//@synthesize appDelegate = _appDelegate;

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
    // this HAS to go through the appDelegate which then talks to the ViewController
    // this will NOT work if you try and talk straight to the ViewController
    //    [appDelegate openVCNetworkDetailView:sender];
    
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
    legendButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    // add in the image
    UIImage *legendCloseButton = [UIImage imageNamed:@"Legend_btn_Close.png"];
    [legendButton setBackgroundImage:legendCloseButton forState:UIControlStateNormal];
    
    // set up the frame placement and the size to be offset
    legendButton.frame = CGRectMake(390, 3, 23, 23);
    // set up the method for moving this resources view up and down
    [legendButton addTarget:self action:@selector(showLegend:) forControlEvents:UIControlEventTouchUpInside];
    [legendButton setUserInteractionEnabled:YES];
    // put this on the resourcesWebView
    [self.legendImageView addSubview:legendButton];
    
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


- (IBAction)openSmallCell:(id)sender {
    if (!self.smallCellViewController) {
        self.smallCellViewController = [[SmallCellViewController alloc] initWithNibName:@"SmallCellViewController" bundle:nil];
    } 
    self.smallCellViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:self.smallCellViewController animated:YES];
    
    // i keep this in to make sure the viewController is removed from the stack because I am using the code above to 
    //     animate the transition home
    // use this if coming from presentModalViewController
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)openIMS:(id)sender {
    if (!self.imsViewController) {
        self.imsViewController = [[IMSViewController alloc] initWithNibName:@"IMSViewController" bundle:nil];
    } 
    self.imsViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:self.imsViewController animated:YES];
    
    // i keep this in to make sure the viewController is removed from the stack because I am using the code above to 
    //     animate the transition home
    // use this if coming from presentModalViewController
    [self dismissModalViewControllerAnimated:YES];
    
}
*/


#pragma mark - View lifecycle

-(void)reconfigurePortrait {
    [self.view setFrame:CGRectMake(0, 0, 1200, 1180)];
}

-(void)reconfigureLandscape {
    [self.view setFrame:CGRectMake(0, 0, 1080, 860)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
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
