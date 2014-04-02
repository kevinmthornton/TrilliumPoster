//  NetworkDetailViewController.h
/*
 The detail of what ever network element the user tapped on from the top network view
 This will need appDelegate to access the letters array set up there from GlossaryData
 I need to do this because of setDetailItem and configureView since these are set from the network views (LTE, IMS...)
 */ 

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class ViewController;
@class InfoViewController;
// @class PDFView;

@interface NetworkDetailViewController : UIViewController <UIWebViewDelegate> {
    NSInteger fileIndex; // this will be set from the button's tag value
    NSString *abbvString; // this will come from the button title and be the lookup for the file
    NSArray *letters;
    AppDelegate *appDelegate; // to get the main array
    ViewController *mainViewController;
    InfoViewController *infoViewController;
    float resourcesYUP;
    float resourcesYDown;
    float resourcesWebFrameY;
    NSString *backButtonNetwork;
    // PDFView *pdfView;
}

@property (strong, nonatomic) id detailItem;

// set from main view controller to be passed in
@property (nonatomic) NSInteger fileIndex;
@property (strong, nonatomic) NSString *abbvString;
@property (strong, nonatomic) NSArray *letters;
@property (strong, nonatomic) UIButton *resourcesButton;
@property (strong, nonatomic) NSString *productImageName;
@property (strong, nonatomic) NSString *stackImageName;
@property (strong, nonatomic) AppDelegate *appDelegate; // for the array reference
@property (strong, nonatomic) ViewController *mainViewController;
@property (strong, nonatomic) InfoViewController *infoViewController;

// for change in orientation
@property float resourcesYUP;
@property float resourcesYDown;
@property float resourcesWebFrameY;

// @property (strong, nonatomic) PDFView *pdfView;

// labels and text fields in the .xib file
@property (weak, nonatomic) IBOutlet UIWebView *networkDetailWebView;
@property (weak, nonatomic) IBOutlet UIWebView *resourcesWebView;
@property (strong, nonatomic) IBOutlet UIImageView *productPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *stackImage;
@property (strong, nonatomic) UIImageView *backgroundNetworkDetailPortrait;
@property (strong, nonatomic) UIImageView *backgroundNetworkDetailLandscape;

// for changing oreientation and moving views around
-(void)reconfigurePortrait;
-(void)reconfigureLandscape;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

// string for the back button to reference
@property (strong, nonatomic) NSString *backButtonNetwork;

// set everything up
- (void)configureView;

// for the action on the resources view, slide up
- (IBAction)showResourcesWebView:(id)sender;

// close this view and return to the previous main network
-(IBAction)closeViewAndReturnToNetwork:(UIButton *)sender;

// are they connected?
- (BOOL) connectedToInternet;

/*
// for the top buttons: About, Contact, Order Poster, Questions
-(IBAction)getInfo:(UIButton *)sender;

// the top HOME button was clicked so, go to main page
-(IBAction)goHome:(id)sender;



// open the links around the edges passing in the sender.currentTitle for IF statement
- (IBAction)openWebLink:(UIButton *)sender;
 
// which button of the protocol stack was clicked?
- (IBAction)showButtonDetail:(UIButton *)sender;
*/

@end
