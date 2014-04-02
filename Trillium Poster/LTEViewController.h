// IMSViewController.h - Trillium Poster
/*
 Show the IMS network layout
 All buttons connect to a method for going to the NetworkDetailViewController
 openSmallCell method opens the smallCellViewController with the button at the right
 openIMS method opens the imsViewController with the button at the top
 */

#import <UIKit/UIKit.h>

//@class AppDelegate;

@interface LTEViewController : UIViewController // talk to the appDelegate to get methods working

// for the blue navigation buttons to other networks
-(IBAction)openNetworkView:(UIButton *)sender ;

// this will be hooked to lots and lots of buttons to show the detail of the button that was clicked
// the button will hold two values, title and tag. title will be the abbreviation of the word that the image refers to 
// tag will be the index number of the letter for which file to open. IE: 0 = 3(.xml), 1 = A(.xml)
- (IBAction)openNetworkDetail:(UIButton *)sender;

// fade in the legend at the bottom of the view
//- (IBAction)showLegend:(id)sender;

// for changing oreientation and moving views around
-(void)reconfigurePortrait;
-(void)reconfigureLandscape;

/*
// open the Small Cell view controller from the right hand button
- (IBAction)openSmallCell:(id)sender;

// open the IMS View Controller from the top button
- (IBAction)openIMS:(id)sender;
*/



@end
