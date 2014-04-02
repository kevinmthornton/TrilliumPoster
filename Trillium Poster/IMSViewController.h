// IMSViewController.h - Trillium Poster
/*
 Show the IMS network layout
 All buttons connect to a method for going to the NetworkDetailViewController
 
 */

#import <UIKit/UIKit.h>

@interface IMSViewController : UIViewController {
//    UIImageView *legendImageView;
}

// view for the legend that will fade in
//@property (weak, nonatomic) IBOutlet UIImageView *legendImageView;
//@property (weak, nonatomic) IBOutlet UIButton *legendButton;

@property (weak, nonatomic) IBOutlet UIButton *lteButton;

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

@end
