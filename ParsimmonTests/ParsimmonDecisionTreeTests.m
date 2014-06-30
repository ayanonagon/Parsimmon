// ParsimmonDecisionTreeTests.m
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
#import "ParsimmonDecisionTree.h"
#import "ParsimmonNode.h"

@interface ParsimmonDecisionTreeTests : XCTestCase
@end

@implementation ParsimmonDecisionTreeTests

- (void)testXOR
{
    ParsimmonDecisionTree *decisionTree = [[ParsimmonDecisionTree alloc] init];
    [decisionTree setFeatureNames:@[@"A", @"B"]];
    [decisionTree setClassificationNames:@[@"zero", @"one"]];
    [decisionTree addSample:@[@1, @1] forClassification:@0];
    [decisionTree addSample:@[@0, @0] forClassification:@0];
    [decisionTree addSample:@[@1, @0] forClassification:@1];
    [decisionTree addSample:@[@0, @1] forClassification:@1];
    [decisionTree build];

    XCTAssertEqual(@0, decisionTree.root.leftChild.leftChild.value, @"Failed 0 XOR 0 case.");
    XCTAssertEqual(@1, decisionTree.root.leftChild.rightChild.value, @"Failed 0 XOR 1 case.");
    XCTAssertEqual(@1, decisionTree.root.rightChild.leftChild.value, @"Failed 1 XOR 0 case.");
    XCTAssertEqual(@0, decisionTree.root.rightChild.rightChild.value, @"Failed 1 XOR 1 case.");

    NSString *zeroZero = [decisionTree classify:@[@0, @0]];
    XCTAssertEqualObjects(@"zero", zeroZero, @"Failed 0 XOR 0 case classification.");

    NSString *zeroOne = [decisionTree classify:@[@0, @1]];
    XCTAssertEqualObjects(@"one", zeroOne, @"Failed 0 XOR 1 case classification.");

    NSString *oneZero = [decisionTree classify:@[@1, @0]];
    XCTAssertEqualObjects(@"one", oneZero, @"Failed 1 XOR 0 case classification.");

    NSString *oneOne = [decisionTree classify:@[@1, @1]];
    XCTAssertEqualObjects(@"zero", oneOne, @"Failed 1 XOR 1 case classification.");
}

- (void)testEmptyTree
{
    ParsimmonDecisionTree *decisionTree = [[ParsimmonDecisionTree alloc] init];
    [decisionTree build];
    XCTAssertNil([decisionTree classify:@[]]);
}

- (void)testAllSameFeatureValues
{
    ParsimmonDecisionTree *decisionTree = [[ParsimmonDecisionTree alloc] init];
    [decisionTree setFeatureNames:@[@"has four legs", @"has whiskers", @"is cute"]];
    [decisionTree setClassificationNames:@[@"cat", @"dog"]];

    // Start off with more cat samples
    [decisionTree addSample:@[@1, @1, @1] forClassification:@0]; // cat
    [decisionTree addSample:@[@1, @1, @1] forClassification:@0]; // cat
    [decisionTree addSample:@[@1, @1, @1] forClassification:@1]; // dog

    [decisionTree build];

    NSString *anotherSample = [decisionTree classify:@[@1, @1, @1]];
    XCTAssertEqualObjects(anotherSample, @"cat");

    // Add some more dog samples
    [decisionTree addSample:@[@1, @1, @1] forClassification:@1]; // dog
    [decisionTree addSample:@[@1, @1, @1] forClassification:@1]; // dog

    [decisionTree build];

    NSString *yetAnotherSample = [decisionTree classify:@[@1, @1, @1]];
    XCTAssertEqualObjects(yetAnotherSample, @"dog");
}



@end
