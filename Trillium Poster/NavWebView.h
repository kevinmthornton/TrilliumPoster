// NavWebView.h - NavigationScroll
/*
 all this does is hold  a big web view that the webURL will be loaded into
 webURL is set outside of this file just before any call to NavWebView
 */

#import <UIKit/UIKit.h>

@interface NavWebView : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (strong, nonatomic) NSURL *webURL;

// not used since this opens in a navigation controller
// close this view and return to the main network image
-(void)closeViewAndReturn;
@end
