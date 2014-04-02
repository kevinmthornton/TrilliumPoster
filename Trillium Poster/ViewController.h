// ViewController.h - NavigationScroll
/*
 This is where everything runs from
 This ViewController has methods for the top buttons as well as methods that run through appDelegate
    from other VC's(IMS, LTE etc...)
 The top buttons run off of getInfo except Home and Video
 Home actually goes to the MainViewController. Don't ask, I just did it this way.
 Video is like Home in that it has it's own method for control
 
 */

#import <UIKit/UIKit.h>
@class AppDelegate;
@class NavWebView;
@class MainViewController;
@class NetworkDetailViewController;
@class IMSViewController;
@class LTEViewController;
@class SmallCellViewController;
@class WCDMAViewController;

@interface ViewController : UIViewController <UIScrollViewDelegate, UIWebViewDelegate> {
    // do not necessarily need these 
    NSString *buttonTitle;
    IBOutlet UIScrollView *mainScrollView;
    UINavigationController *navController;
    NavWebView *navWebView; // this will be used with the navigation controller
    NetworkDetailViewController *networkDetailViewController;
}

// determine where to to based on the buttonTitle property
@property (strong, nonatomic) NSString *buttonTitle;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) NavWebView *navWebView;
// where everything loads
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
// the info web view for the buttons up top
@property (strong, nonatomic) IBOutlet UIWebView *infoWebView;
@property (strong, nonatomic) IBOutlet UIButton *intelButton;

// all the other VC's
@property (strong, nonatomic) AppDelegate *appDelegate; 
@property (strong, nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) NetworkDetailViewController *networkDetailViewController;

// all the network view controllers
@property (strong, nonatomic) IMSViewController *imsViewController;
@property (strong, nonatomic) LTEViewController *lteViewController;
@property (strong, nonatomic) SmallCellViewController *smallCellViewController;
@property (strong, nonatomic) WCDMAViewController *wcdmaViewController;
// views for the legend that will fade in when the network views are displayed
@property (weak, nonatomic) IBOutlet UIButton *legendButton;
@property (weak, nonatomic) IBOutlet UIImageView *legendImageView;

// show the legend button in order to fade in the legend
-(void)showLegendButton:(NSNotification *)notification;
// fade in the legend at the bottom of the view
- (IBAction)showLegend:(id)sender;

// instead of video view controller
@property (strong, nonatomic) NSURL *videosUrl;
@property (strong, nonatomic) NSDictionary *videoDictionary;
@property (strong, nonatomic) NSArray *categoryNames;
@property (strong, nonatomic) IBOutlet UIWebView *videoWebView;
@property (strong, nonatomic) IBOutlet UIView *videoBackgroundView;
@property (strong, nonatomic) IBOutlet UIScrollView *thumbNailScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *buttonScrollView;
@property (strong, nonatomic) IBOutlet UIView *leftArrowView; // right arrow for thumbnails
@property (strong, nonatomic) IBOutlet UIView *rightArrowView; // right arrow for thumbnails
@property (strong, nonatomic) IBOutlet UIImageView *rightCap; // right arrow for thumbnails
@property (nonatomic) float screenWidth;
@property (nonatomic) float startX;
@property (strong, nonatomic) UIButton *leftArrowButton;
@property (strong, nonatomic) UIButton *rightArrowButton;

// VIDEO methods
- (IBAction)openVideo:(UIButton *)sender;
- (void)loadVideo:(UIButton *)videoName;
- (IBAction)loadThumbNails:(UIButton *)sender;

// hide all the views 
-(void)hideAllViews;

// load up the main view controller from the top button
- (IBAction)openMain;

// talks to appDelegate to control views inside of mainScrollView
-(IBAction)openNetworkView:(UIButton *)sender;

// talks to appDelegate to control views inside of mainScrollView for opening the network detail(HSS) of each network(IMS)
-(IBAction)openNetworkDetailView:(UIButton *)sender;

// clear out all views from mainScrollView
-(void)clearMainScrollView;

// top buttons navigation
-(IBAction)getInfo:(UIButton *)sender;

// open the links around the edges passing in the sender.currentTitle for IF statement
- (IBAction)openWebLink:(UIButton *)sender;

// from the networkDetailViewController back button
// load in the network passed to the mainScrollView
-(void)backToNetwork:(NSString *)backButtonNetwork;


// for reworking the view when orientation changes
-(void)reconfigurePortrait;
-(void)reconfigureLandscape;


@end



