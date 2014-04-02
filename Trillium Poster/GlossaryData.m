//
//  GlossaryData.m
//  Glossary
//
//  Created by kevin thornton on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GlossaryData.h"


@implementation GlossaryData

// @synthesize glossaryContent = _glossaryContent;
// @synthesize letters = _letters;
// @synthesize row = _row;

// static NSString *letters = @"3abcd"; //efghijklmnopqrstuvwxyz

+ (NSArray *) createGlossaryData {
    NSMutableArray *letters = [[NSMutableArray alloc] init];
    
    letters = [[NSMutableArray alloc] initWithObjects:@"3", @"A", @"B", @"C", @"D",@"E",@"F",@"G",@"H",@"I",@"L",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    NSMutableArray *glossaryContent = [[NSMutableArray alloc] initWithCapacity:[letters count]];
    // this will iterate through the letters string and open up each LETTER.xml file reading it's contents
    // the contents of the file will be a dictionary of abbvriation of the word => name, description
    // hopefully, we will get more data for each abbv as time goes on
    // i want to place into glossaryContent the values A => AAA, AAL, AIN B => B-ISUP, B2BUA, etc...
    
    
    for (int i = 0; i < [letters count]; i++ ) {
        NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
        // this is to hold the data that goes into glossaryContent one at a time
        NSString *stringLetter = [letters objectAtIndex:i];    
        // grab this file out of the resources folder
        NSURL *letterUrl = [[NSBundle mainBundle] URLForResource:stringLetter withExtension:@"xml"];
        // set up the dictionary
        NSDictionary *letterDictionary = [[NSDictionary alloc ] initWithContentsOfURL:letterUrl];
        
        [row setValue:stringLetter forKey:@"headerTitle"];
        [row setValue:[[letterDictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] forKey:@"rowValues"];
        // NSLog(@"row: %@",row);
        [glossaryContent addObject:row];
    }
    
    // NSLog(@"glossaryContent: %@", glossaryContent);
    // send back the array with the letters linking to the file data
    return glossaryContent;
}

@end
