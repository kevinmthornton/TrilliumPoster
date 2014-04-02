// InfoViewController.h - NavigationScroll
/*
 this controls all the text info from the top buttons
 i use the appDelegate to call into the ViewController and load this .xib up in the mainScrollView
 */

#import <UIKit/UIKit.h>
@class AppDelegate;

@interface InfoViewController : UIViewController <UIWebViewDelegate> {
    AppDelegate *appDelegate;
    NSString *buttonTitle;
    
}
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;
@property (strong, nonatomic) NSString *buttonTitle;
@property (strong, nonatomic) id detailItem;

// for the top buttons: About, Contact, Order Poster, Questions
// use the main vc for all these funtions
// -(IBAction)getInfo:(UIButton *)sender;

// open the links around the edges passing in the sender.currentTitle for IF statement
- (IBAction)openWebLink:(UIButton *)sender;

// are we connected?
- (BOOL) connectedToInternet;

@end
