// AppDelegate.m - Trillium Poster
/*
  this is where our main array is built from GlossaryData
 
 in AppDelegate.m
 1) start a letters array
 2) open up each file in the array and get it's abbv contents
 3) in ViewController
 1) reference this array from the appD 
 2) target a button with the title/tag
 3) buttons submits to a ContentView
 4) Content view takes passed info from button and opens correct file
 1) open up the file and get the abbv contents
 2) parse contents for values and display on screen

 */

// TODO!! rework app delegate down to stub code and use the view controller for all interaction now since 
// you are loading all interaction through mainScrollView

#import "AppDelegate.h"
#import "ViewController.h"
#import "GlossaryData.h" // creates all main XML data array with the abbvString relationships

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize contentAppArray, indicesAppArray, lettersAppArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // ARRAYS with all the XML info inside them from the GlossaryData.h
    contentAppArray = [GlossaryData createGlossaryData];
    indicesAppArray = [contentAppArray valueForKey:@"headerTitle"];
    // set up the letters array to be used for opening the XML files
    lettersAppArray = [[NSMutableArray alloc] initWithObjects:@"3", @"A", @"B", @"C", @"D",@"E",@"F",@"G",@"H",@"I",
                       @"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];

        
    // set up the main view controller
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
