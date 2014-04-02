// VideoViewController.h 
/*
 main video up top gets loaded with whatever the first 'featured' video is
 these are loaded from an XML file on radisys.com
 must have a connection to view this page
 buttons at bottom load in the thumbnails from videos
 these will be dynamic buttons that I assign the method loadVideo:(NSString *)videoName
 videoName will come from the title of the button which will come from the XML file
 the button itself will be an image from the XML file
 
 video thumbnails load in main video
 
 */

#import <UIKit/UIKit.h>


// set up the delegates for this VC
@interface VideoViewController : UIViewController {
    NSURL *videosUrl;
    NSDictionary *videoDictionary;
    NSArray *categoryNames;
}

@property (strong, nonatomic) NSURL *videosUrl;
@property (strong, nonatomic) NSDictionary *videoDictionary;
@property (strong, nonatomic) NSArray *categoryNames;

@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (weak, nonatomic) IBOutlet UIScrollView *thumbNailScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *buttonScrollView;

- (void)loadVideo:(UIButton *)videoName;

- (IBAction)loadThumbNails:(UIButton *)sender;

@end
