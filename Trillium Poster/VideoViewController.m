// VideoViewController.m
#import "VideoViewController.h"



@implementation VideoViewController
@synthesize videosUrl;
@synthesize videoDictionary;
@synthesize categoryNames;

@synthesize mainWebView;
@synthesize thumbNailScrollView;
@synthesize buttonScrollView;

// click on one of the thumbnails and pass in the button 
// grab button title and load up that video from the XML
-(void)loadVideo:(UIButton *)videoName {
    
    
}

// pass in the button name and grab it's title
// open XML file ad get a list of thumbnails to display in thumbNailScrollView
- (IBAction)loadThumbNails:(UIButton *)sender {
    // the sender.currentTitle will get you the key to the array of thumbnails
    NSString *categoryName = sender.currentTitle;
    // get the array of thumbnail information
    NSArray *thumbNailArray = [videoDictionary valueForKey:categoryName];
    // NSLog(@"thumbNailArray: %@", thumbNailArray);
    
    // set up the first x and y for the buttons
    float startX = 20.;
    float startY = 10.;
    float buttonWidth = 195.;
    float buttonHeight = 95.;
    
    // do these for the label
    float startXLabel = 20.;
    float startYLabel = 110.;
    float labelWith = 195.;
    float labelHeight = 55.;
    
    // iterate through the array and add these to the thumbNailScrollView with some space
    for (NSDictionary *thumbNailDictionary in thumbNailArray) {
        // assign this to the label under the button
        NSString *thumbTitle = [thumbNailDictionary objectForKey:@"Title"];
        // assign this as the button image
        NSString *thumbImageName = [thumbNailDictionary objectForKey:@"Thumbnail"];
        
        
        // get image data FROM WEB SITE
        // create string for the images name
        NSString *thumbImageString = [[NSString alloc] initWithFormat:@"http://www.radisys.com/prebuilt/trillium-poster/video/%@",thumbImageName];
        // create the URL for the thumbnail
        NSURL *thumbImageURL = [NSURL URLWithString:thumbImageString];
        // grab the data
        NSData *thumbImageData = [NSData dataWithContentsOfURL:thumbImageURL];
        // local file
        // UIImage *thumbImage = [UIImage imageNamed:thumbImageName];
        UIImage *thumbImage = [UIImage imageWithData:thumbImageData];
        // assign this as the buttons title so we can pass into the loadVideo
        NSString *thumbVideo = [thumbNailDictionary objectForKey:@"Video"];
        
        // create the button and add it to buttonScrollView
        // place the button on the view on top of each other
        UIButton *thumbButton =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
        // set up the frame placement and the size
        thumbButton.frame = CGRectMake(startX, startY, buttonWidth, buttonHeight);
        // set up the title for the button
        [thumbButton setTitle:thumbVideo forState:UIControlStateNormal];
        [thumbButton setImage:thumbImage forState:UIControlStateNormal];
        // assign this button a method for when pressed
        [thumbButton addTarget:self action:@selector(loadVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        // EXAMPLE
        /*
         
         CGSize labelsize;
         UILabel *commentsTextLabel = [[UILabel alloc] init];;
         [commentsTextLabel setNumberOfLines:0];
         [commentsTextLabel setBackgroundColor:[UIColor clearColor]];
         NSString *text = @"fjkldsjfkladsjfkljsdaklfjadsklfjdskjfdskjflkdsahfahfdkdfdsfasdfasdfafjkldsjfkladsjfklhfahfdkdfdsfasdfasdfassfjklds";
         
         [commentsTextLabel setFont:[UIFont fontWithName:@"Helvetica"size:14]];
         labelsize=[text sizeWithFont:commentsTextLabel.font constrainedToSize:CGSizeMake(268, 2000.0) lineBreakMode:UILineBreakModeWordWrap];
         commentsTextLabel.frame=CGRectMake(10, 24, 268, labelsize.height);
         
         */
        
        
        // custom label size
        // CGSize labelSize;
        // UILabel *thumbLabel = [[UILabel alloc] init];
        
        // now do the label
        UILabel *thumbLabel = [[UILabel alloc] initWithFrame:CGRectMake(startXLabel, startYLabel, labelWith, labelHeight)];
        
        [thumbLabel setFont:[UIFont fontWithName:@"Helvetica"size:18]];
        // CUSTOM didn't work labelSize=[thumbTitle sizeWithFont:thumbLabel.font constrainedToSize:CGSizeMake(268, 2000.0) lineBreakMode:UILineBreakModeWordWrap];
        // set up 2 lines centered with word wrap
        [thumbLabel setNumberOfLines:2];
        [thumbLabel setLineBreakMode:UILineBreakModeWordWrap];
        [thumbLabel setTextAlignment:UITextAlignmentCenter];
        [thumbLabel setText:thumbTitle];
        // CUSTOM didn't work [thumbLabel setFrame:CGRectMake(startXLabel, startYLabel, labelWith, labelSize.height)];
        
        // add this to buttonScrollView
        [self.thumbNailScrollView addSubview:thumbButton];
        [self.thumbNailScrollView addSubview:thumbLabel];
        
        // increment X so that the buttons stack next to each other
        // have to play with font size of buttons to get all these on screen
        startX += 205.;
        startXLabel += 205.;
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up the data in arrays and dictionaries
    // open xml file FROM WEB SITE and get data
    
    
    // local file
    // videosUrl = [[NSBundle mainBundle] URLForResource:@"Videos" withExtension:@"xml"];
    // web file
    videosUrl = [NSURL URLWithString:@"http://www.radisys.com/prebuilt/trillium-poster/video/Videos.xml"];
    // set up the dictionary
    videoDictionary = [[NSDictionary alloc ] initWithContentsOfURL:videosUrl];
    categoryNames =  [videoDictionary allKeys];
    // NSLog(@"categoryNames: %@", categoryNames);
    // get all the keys for the category buttons - these will be the button titles
    
    
    // set up the thumbNailScrollView size for scrolling
    [thumbNailScrollView setScrollEnabled:YES];
    // CALCULATE this based on the number of thumbnails?
    [thumbNailScrollView setContentSize:CGSizeMake(1100, 125)];
    
    // set up the thumbNailScrollView size for scrolling
    [buttonScrollView setScrollEnabled:YES];
    // CALCULATE this based on the number of thumbnails?
    [thumbNailScrollView setContentSize:CGSizeMake(1100, 40)];
    
    // set up the first x and y for the buttons
    float startX = 20.;
    float startY = 10.;
    float buttonWidth = 125.;
    float buttonHeight = 25.;
    
    // load up the buttons into the buttonScrollView
    // these are all the categories from the XML
    for (NSString *categoryName in categoryNames) {
        // create the button and add it to buttonScrollView
        // place the button on the view on top of each other
        UIButton *connectionButton =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
        // set up the frame placement and the size
        connectionButton.frame = CGRectMake(startX, startY, buttonWidth, buttonHeight);
        // set up the title for the button
        [connectionButton setTitle:categoryName forState:UIControlStateNormal];
        
        // assign this button a method for when pressed
        [connectionButton addTarget:self action:@selector(loadThumbNails:) forControlEvents:UIControlEventTouchUpInside];
        
        // add this to buttonScrollView
        [self.buttonScrollView addSubview:connectionButton];
        
        // increment X so that the buttons stack next to each other
        // have to play with font size of buttons to get all these on screen
        startX += 125.;
    }
    
    // we dont' have any of the video's formatted just yet
    
	// load up the mainWebView with the first video in the featured section
	NSURL *siteURL = [[NSURL alloc] initWithString:@"http://mobile.epickites.com/videos/intro.mov"];
	NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:siteURL];
	// [mainWebView loadRequest:urlRequest];
	// [self.view addSubview:mainWebView];
}

// are we connected?


- (void)viewDidUnload {
    [self setMainWebView:nil];
    [self setThumbNailScrollView:nil];
    [self setButtonScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    
    // NOW reconfigure based on oreientation lke in ViewController.m 
    
    
    NSLog(@"video did rotate");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"video auto rotate");
    return YES;
}


@end
