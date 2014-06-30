// ParsimmonNaiveBayesClassifierTests.m
//
// Copyright (c) 2014 Ayaka Nonaka
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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

    XCTAssertEqualObjects([classifier classify:firstExample], @"ham");
    XCTAssertEqualObjects([classifier classify:secondExample], @"spam");
}

@end
