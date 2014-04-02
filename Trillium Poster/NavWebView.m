// NavWebView.m - NavigationScroll
/*
 this opens up in a navigation controller that is set up in ViewController > viewDidLoad
 */


#import "NavWebView.h"

@interface NavWebView ()

@end

@implementation NavWebView
@synthesize mainWebView;
@synthesize webURL = _webURL;

-(void)viewWillAppear:(BOOL)animated {
//    NSLog(@"navwebview viewDidload, %@", self.webURL);
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:self.webURL];
    [self.mainWebView loadRequest:urlRequest];
    
    // for the navigation controller
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(closeViewAndReturn)];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.leftBarButtonItem = backButton;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

// close this view and return to the main network image
-(void)closeViewAndReturn {
//    NSLog(@"closeViewAndReturn");
    [self setWebURL:nil];
	// remove me and return to the previous page
    // if you do an animated, you use this
    [self dismissModalViewControllerAnimated:YES];
    // if you do an addSubView, you use this
    // [self.view removeFromSuperview];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidUnload
{
    [self setMainWebView:nil];
    [self setWebURL:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
