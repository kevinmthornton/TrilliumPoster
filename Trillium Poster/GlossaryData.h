//
//  GlossaryData.h
//  Glossary

// this provides the dictionary/array that used in the selecting of the data


#import <Foundation/Foundation.h>

@interface GlossaryData : NSObject {
    // NSMutableArray *glossaryContent;
    // NSMutableArray *letters;
    // NSArray *row;
}

// @property(nonatomic, strong) NSMutableArray *glossaryContent;
// @property(nonatomic, strong) NSMutableArray *letters;
// @property(nonatomic, strong) NSArray *row;

// class(+) method that returns a value
+ (NSArray *) createGlossaryData;

@end
