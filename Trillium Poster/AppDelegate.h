// AppDelegate.h - Trillium Poster
/*
 V2 of the Trillium Poster
 ViewController is just the holder of a top/bottom navigation and a large scroll view that everything loads into
 The buttons are all run out of the ViewController 
 
 */

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    ViewController *viewController;
    // for the network detail view controller
    NSArray *contentAppArray;
    NSArray *indicesAppArray;
    NSArray *lettersAppArray;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) NSArray *contentAppArray;
@property (strong, nonatomic) NSArray *indicesAppArray;
@property (strong, nonatomic) NSArray *lettersAppArray;

@end
