//
//  ParsimmonNaiveBayesClassifierTests.m
//  Parsimmon
//
//  Created by Ayaka Nonaka on 6/20/14.
//
//

#import <XCTest/XCTest.h>
#import "ParsimmonNaiveBayesClassifier.h"

@interface ParsimmonNaiveBayesClassifierTests : XCTestCase
@end

@implementation ParsimmonNaiveBayesClassifierTests

- (void)testBasicExample
{
    ParsimmonNaiveBayesClassifier *classifier = [[ParsimmonNaiveBayesClassifier alloc] init];

    // Train the classifier with some ham examples.
    [classifier trainWithText:@"nom nom ham" category:@"ham"];
    [classifier trainWithText:@"make sure to get the ham" category:@"ham"];
    [classifier trainWithText:@"please put the eggs in the fridge" category:@"ham"];

    // Train the classifier with some spam examples.
    [classifier trainWithText:@"spammy spam spam" category:@"spam"];
    [classifier trainWithText:@"what does the fox say?" category:@"spam"];
    [classifier trainWithText:@"and fish go blub" category:@"spam"];

    // Classify some new text. Is it ham or spam?
    // In practice, you'd want to train with more examples first.
    NSString *firstExample = @"use the eggs in the fridge.";
    NSString *secondExample = @"what does the fish say?";

    XCTAssertEqual([classifier classify:firstExample], @"ham");
    XCTAssertEqual([classifier classify:secondExample], @"spam");
}

@end
