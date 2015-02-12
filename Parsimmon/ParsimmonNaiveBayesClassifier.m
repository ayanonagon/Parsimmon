// ParsimmonNaiveBayesClassifier.m
// 
// Copyright (c) 2013 Ayaka Nonaka
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

#import "ParsimmonNaiveBayesClassifier.h"
#import "ParsimmonTokenizer.h"

#define kParsimmonSmoothingParameter 1

@interface ParsimmonNaiveBayesClassifier ()
@property (strong, nonatomic) ParsimmonTokenizer *tokenizer;
@property (strong, nonatomic) NSMutableDictionary *wordOccurrences;
@property (strong, nonatomic) NSMutableDictionary *categoryOccurrences;
@property (assign, nonatomic) NSUInteger trainingCount;
@property (assign, nonatomic) NSUInteger wordCount;
@end

@implementation ParsimmonNaiveBayesClassifier

- (instancetype)init
{
    ParsimmonTokenizer *tokenizer = [[ParsimmonTokenizer alloc] init];
    return [self initWithTokenizer:tokenizer];
}

- (instancetype)initWithTokenizer:(ParsimmonTokenizer *)tokenizer
{
    self = [super init];
    if (self) {
        self.tokenizer = tokenizer;
        self.wordOccurrences = [NSMutableDictionary dictionary];
        self.categoryOccurrences = [NSMutableDictionary dictionary];
    }
    return self;
}


#pragma mark - Training

- (void)trainWithText:(NSString *)text category:(NSString *)category
{
    [self trainWithTokens:[self.tokenizer tokenizeWordsInText:text] category:category];
}

- (void)trainWithTokens:(NSArray *)tokens category:(NSString *)category
{
    NSArray *words = [self removeDuplicates:tokens];
    for (NSString *word in words) {
        [self incrementWord:word category:category];
    }
    [self incrementCategory:category];
    self.trainingCount += 1;
}


#pragma mark - Classifying

- (NSString *)classify:(NSString *)text
{
    return [self classifyTokens:[self.tokenizer tokenizeWordsInText:text]];
}

- (NSString *)classifyTokens:(NSArray *)tokens
{
    // Compute argmax_cat [log(P(C=cat)) + sum_token(log(P(W=token|C=cat)))]
    CGFloat maxScore = -CGFLOAT_MAX;
    NSString *bestCategory;
    for (NSString *category in [self.categoryOccurrences allKeys]) {
        CGFloat currentCategoryScore = 0;
        CGFloat pCategory = [self pCategory:category]; // P(C=cat)
        currentCategoryScore += log(pCategory); // log(P(C=cat))
        for (NSString *token in tokens) { // sum_token
            // P(W=token|C=cat) = P(C=cat, W=token) / P(C=cat)
            CGFloat numerator = [self pCategory:category andWord:token];
            // Do some smoothing
            CGFloat pWordGivenCategory = (numerator + kParsimmonSmoothingParameter) /
                    (pCategory + kParsimmonSmoothingParameter * self.wordCount);
            currentCategoryScore += log(pWordGivenCategory); // log(P(W=token|C=cat))
        }
        // Update the argmax if necessary
        if (currentCategoryScore > maxScore) {
            maxScore = currentCategoryScore;
            bestCategory = category;
        }
    }
    return bestCategory;
}


#pragma mark - Probabilities

/**
 Returns P(C=category, W=word).
 @param category The category
 @param word The word
 @return P(C=category, W=word)
 */
- (CGFloat)pCategory:(NSString *)category andWord:(NSString *)word
{
    if (!self.wordOccurrences[word] || !self.wordOccurrences[word][category]) {
        return 0;
    }
    return ([self.wordOccurrences[word][category] floatValue]) / self.trainingCount;
}

/**
 Return P(C=category).
 @param category The category.
 @return P(C=category)
 */
- (CGFloat)pCategory:(NSString *)category
{
    return [self totalOccurrencesOfCategory:category] / self.trainingCount;
}


#pragma mark - Counting

- (void)incrementWord:(NSString *)word category:(NSString *)category
{
    if (!self.wordOccurrences[word]) {
        self.wordOccurrences[word] = [NSMutableDictionary new];
        self.wordCount += 1;
    }
    if (!self.wordOccurrences[word][category]) {
        self.wordOccurrences[word][category] = @0;
    }
    NSUInteger wordCategoryCount = [self.wordOccurrences[word][category] integerValue];
    self.wordOccurrences[word][category] = @(wordCategoryCount + 1);
}

- (void)incrementCategory:(NSString *)category
{
    if (!self.categoryOccurrences[category]) {
        self.categoryOccurrences[category] = @0;
    }
    NSUInteger categoryCount = [self.categoryOccurrences[category] integerValue];
    self.categoryOccurrences[category] = @(categoryCount + 1);
}

- (CGFloat)totalOccurrencesOfWord:(NSString *)word
{
    if (!self.wordOccurrences[word]) {
        return 0;
    }
    CGFloat totalOccurrencesOfWord = 0;
    for (NSString *category in self.wordOccurrences[word]) {
        totalOccurrencesOfWord += [self.wordOccurrences[word][category] floatValue];
    }
    return totalOccurrencesOfWord;
}

- (CGFloat)totalOccurrencesOfCategory:(NSString *)category
{
    return [self.categoryOccurrences[category] floatValue];
}


#pragma mark - Helpers

- (NSArray *)removeDuplicates:(NSArray *)array
{
    NSSet *set = [NSSet setWithArray:array];
    return [set allObjects];
}

@end
