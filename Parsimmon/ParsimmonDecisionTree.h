// ParsimmonDecisionTree.h
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

#import <Foundation/Foundation.h>

@class ParsimmonNode;

/**
 ## Sample usage

    ParsimmonDecisionTree *decisionTree = [[ParsimmonDecisionTree alloc] init];
    [decisionTree setFeatureNames:@[@"A", @"B"]];
    [decisionTree setClassificationNames:@[@"zero", @"one"]];
    [decisionTree addSample:@[@1, @1] forClassification:@0];
    [decisionTree addSample:@[@0, @0] forClassification:@0];
    [decisionTree addSample:@[@1, @0] forClassification:@1];
    [decisionTree addSample:@[@0, @1] forClassification:@1];
    [decisionTree build];

    NSLog(@"%@", [decisionTree classify:@[@0, @0]]);
    NSLog(@"%@", [decisionTree classify:@[@0, @1]]);
    NSLog(@"%@", [decisionTree classify:@[@1, @0]]);
    NSLog(@"%@", [decisionTree classify:@[@1, @1]]);

 Output:
    zero
    one
    one
    zero

 */
@interface ParsimmonDecisionTree : NSObject

@property (strong, nonatomic) ParsimmonNode *root;
@property (assign, nonatomic) NSUInteger maxDepth; // The default is 5.

/**
 Creates a parsimmon decision tree instance.
 @return The initialized tree
 */
- (instancetype)init;

/**
 Gives meaningful labels to the features used in the decision tree.
 @param featureNames The list of feature names
 */
- (void)setFeatureNames:(NSArray *)featureNames;

/**
 Gives a meaningful labels to the classifications used in the decision tree (e.g. ham, spam).
 @param classificationNames The classification names
 */
- (void)setClassificationNames:(NSArray *)classficationNames;

/**
 Adds a data point to the decision tree.
 @param binaryFeatureValues The list of binary values (@0 or @1) for each of the features.
 @param zeroOrOne The binary value (@0 or @1) for the classification
 */
- (void)addSample:(NSArray *)binaryFeatureValues forClassification:(NSNumber *)zeroOrOne;

/**
 Builds the decision tree based on the data it has.
 */
- (void)build;

- (NSString *)classify:(NSArray *)sample;

@end
