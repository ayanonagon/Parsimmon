// ParsimmonDecisionTree.m
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

#import "ParsimmonDecisionTree.h"
#import "ParsimmonNode.h"

#define PARSIMMON_DECISION_TREE_DEFAULT_MAX_DEPTH 5

@interface ParsimmonDecisionTree ()

@property (strong, nonatomic) NSArray *featureNames;
@property (strong, nonatomic) NSArray *classificationNames;
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation ParsimmonDecisionTree

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxDepth = PARSIMMON_DECISION_TREE_DEFAULT_MAX_DEPTH;
        self.data = [NSMutableArray array];
    }
    return self;
}


#pragma mark - Building the Model

- (void)setFeatureNames:(NSArray *)featureNames
{
    _featureNames = featureNames;
}

- (void)setClassificationNames:(NSArray *)classficationNames
{
    _classificationNames = classficationNames;
}

- (void)addSample:(NSArray *)binaryFeatureValues forClassification:(NSNumber *)zeroOrOne
{
    NSMutableArray *datum = [NSMutableArray arrayWithArray:binaryFeatureValues];
    [datum addObject:zeroOrOne];
    [self.data addObject:datum];
}

- (void)build {
    NSArray *featuresArray = [self featuresNumberArrayWithCount:[self.featureNames count]];
    self.root = [self decisionTreeFromData:self.data remainingFeatures:featuresArray maxDepth:self.maxDepth];
}

- (ParsimmonNode *)decisionTreeFromData:(NSArray *)data
                      remainingFeatures:(NSArray *)remainingFeatures
                               maxDepth:(NSUInteger)maxDepth
{
    if (![data count]) {
        return nil;
    }

    ParsimmonNode *node = [[ParsimmonNode alloc] init];

    // Check for the two base cases.
    NSArray *firstDatum = data[0];
    NSArray *firstDatumFeatureValues = [self subarrayOfArray:firstDatum atIndices:remainingFeatures];
    NSNumber *firstDatumClassification = [firstDatum lastObject];

    BOOL allSameClassification = YES;
    BOOL allSameFeatureValues = YES;
    NSUInteger count = 0;
    for (NSArray *datum in data) {
        NSNumber *datumClassification = [datum lastObject];
        if (firstDatumClassification != datumClassification) {
            allSameClassification = NO;
        }
        NSArray *datumFeatureValues = [self subarrayOfArray:datum atIndices:remainingFeatures];
        if (![firstDatumFeatureValues isEqualToArray:datumFeatureValues]) {
            allSameFeatureValues = NO;
        }
        count += [datumClassification integerValue];
    }

    if (allSameClassification) {
        node.value = [firstDatum lastObject];
    } else if (allSameFeatureValues || maxDepth == 0) {
        node.value = count > [data count] / 2 ? @1 : @0;
    } else {
        // Find the best feature to split on and recurse.
        CGFloat maxIG = -CGFLOAT_MAX;
        NSUInteger bestFeature = 0;
        for (NSNumber *feature in remainingFeatures) {
            CGFloat IG = [self informationGainWithFeature:[feature integerValue] forData:data];
            if (IG >= maxIG) {
                maxIG = IG;
                bestFeature = [feature unsignedIntegerValue];
            }
        }
        NSArray *splitData = [self splitData:data onFeature:bestFeature];
        NSMutableArray *newRemainingFeatures = [remainingFeatures mutableCopy];
        [newRemainingFeatures removeObject:@(bestFeature)];
        node.leftChild = [self decisionTreeFromData:splitData[0] remainingFeatures:newRemainingFeatures maxDepth:maxDepth - 1];
        node.rightChild = [self decisionTreeFromData:splitData[1] remainingFeatures:newRemainingFeatures maxDepth:maxDepth - 1];
        node.value = @(bestFeature);
    }

    return node;
}

- (NSArray *)splitData:(NSArray *)data onFeature:(NSUInteger)feature
{
    NSMutableArray *first = [NSMutableArray new];
    NSMutableArray *second = [NSMutableArray new];
    for (NSArray *datum in data) {
        if ([datum[feature] isEqual:@0]) {
            [first addObject:datum];
        } else {
            [second addObject:datum];
        }
    }
    return @[first, second];
}

- (NSArray *)subarrayOfArray:(NSArray *)array atIndices:(NSArray *)indices
{
    NSMutableArray *subarray = [NSMutableArray new];
    for (NSNumber *idx in indices) {
        [subarray addObject:[array objectAtIndex:[idx unsignedIntegerValue]]];
    }
    return subarray;
}


#pragma mark - Classifying

- (NSString *)classify:(NSArray *)sample
{
    ParsimmonNode *node = self.root;
    while (node) {
        if (!node.leftChild) {
            NSString *result = [self.classificationNames objectAtIndex:[node.value integerValue]] ?: [node.value stringValue];
            return result;
        } else {
            NSNumber *pathToTake = [sample objectAtIndex:[node.value integerValue]];
            if ([pathToTake isEqual: @0]) {
                node = node.leftChild;
            } else {
                node = node.rightChild;
            }
        }
    }
    return nil;
}


#pragma mark - Entropy

- (CGFloat)informationGainWithFeature:(NSUInteger)feature forData:(NSArray *)data
{
    return [self HYforData:data] - [self HYgivenX:feature forData:data];
}

- (CGFloat)HYforData:(NSArray *)data
{
    CGFloat pY0 = [self pY:@0 forData:data];
    CGFloat pY1 = 1 - pY0;
    return -1 * (pY0 * log2(pY0) + pY1 * log2(pY1));
}

- (CGFloat)HYgivenX:(NSUInteger)X forData:(NSArray *)data
{
    CGFloat result = 0;
    for (NSNumber *x in @[@0, @1]) {
        for (NSNumber *y in @[@0, @1]) {
            result -= [self pX:x andY:y forData:data lookingAtFeature:X] * log2([self pY:y givenX:x forData:data lookingAtFeature:X]);
        }
    }
    return result;
}

- (CGFloat)pY:(NSNumber *)y forData:(NSArray *)data
{
    NSUInteger count = 0;
    for (NSArray *datum in data) {
        NSNumber *datumClassification = [datum lastObject];
        if ([datumClassification isEqual:y]) {
            count++;
        }
    }
    return (CGFloat)count / [data count];
}

- (CGFloat)pX:(NSNumber *)x andY:(NSNumber *)y forData:(NSArray *)data lookingAtFeature:(NSUInteger)feature
{
    NSUInteger count = 0;
    for (NSArray *datum in data) {
        NSNumber *datumClassification = [datum lastObject];
        NSNumber *featureValue = datum[feature];
        if ([datumClassification isEqual:y] && [featureValue isEqual:x]) {
            count++;
        }
    }
    return (CGFloat)count / [data count];
}

- (CGFloat)pY:(NSNumber *)y givenX:(NSNumber *)x forData:(NSArray *)data lookingAtFeature:(NSUInteger)feature
{
    NSUInteger count = 0;
    NSUInteger xCount = 0;
    for (NSArray *datum in data) {
        NSNumber *featureValue = datum[feature];
        if ([featureValue isEqual:x]) {
            xCount++;
            NSNumber *datumClassification = [datum lastObject];
            if ([datumClassification isEqual:y]) {
                count++;
            }
        }
    }
    return (CGFloat)count / xCount;
}


#pragma mark - Helpers

- (NSArray *)featuresNumberArrayWithCount:(NSUInteger)count {
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger i = 0; i < count; i++) {
        [result addObject:@(i)];
    }
    return result;
}

@end
