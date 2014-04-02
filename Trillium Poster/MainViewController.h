// MainViewController.h - NavigationScroll
/*
 MAIN landing page - this is where you start by seeing all the main networks views
    IMS, LTE, LTE-A, etc...
 This main UIView is tagged 111 so that it can be reconginzed by ViewController:viewForZoomingInScrollView:
    we have to return this view as the scrollable view and remove the rest in ViewController:clearMainScrollView
 
 */

#import <UIKit/UIKit.h>
@class AppDelegate;
@class ViewController;

@interface MainViewController : UIViewController {
    AppDelegate *appDelegate;
    IBOutlet ViewController *viewController;
}

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet ViewController *viewController;
@property (strong, nonatomic) IBOutlet UITextView *mainText;
@property (weak, nonatomic) IBOutlet UIImageView *helpView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundLines;
@property (strong, nonatomic) IBOutlet UIButton *imsButton;
@property (strong, nonatomic) IBOutlet UIButton *lteButton;
@property (strong, nonatomic) IBOutlet UIButton *lteAButton;
@property (strong, nonatomic) IBOutlet UIButton *smallCellButton;
@property (strong, nonatomic) IBOutlet UIButton *wcdmaButton;
@property (strong, nonatomic) IBOutlet UIImageView *commNetworkTitleView;

// this talks to the notification center 
-(IBAction)openNetworkView:(UIButton *)sender;

// for ui orientation
-(void)reconfigurePortrait;
-(void)reconfigureLandscape;
// this is the window that pops up at the very begining of the app to explain what to do
-(IBAction)showHelpView;

// not used now but, could be useful in the future
-(void)removeFromScrollView;

@end
