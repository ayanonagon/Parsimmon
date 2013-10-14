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

#define kParsimmonNaiveBayesClassifierMinValue 0.000001

@interface ParsimmonNaiveBayesClassifier ()
@property (strong, nonatomic) ParsimmonTokenizer *tokenizer;
@property (strong, nonatomic) NSMutableDictionary *wordOccurences;
@property (strong, nonatomic) NSMutableDictionary *categoryOccurences;
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
    }
    return self;
}

- (void)trainWithText:(NSString *)text category:(NSString *)category
{
    [self trainWithTokens:[self.tokenizer tokenizeWordsInText:text] category:category];
}

- (void)trainWithTokens:(NSArray *)tokens category:(NSString *)category
{
    NSArray *words = [self removeDuplicates:tokens];
    for (NSString *word in words) {
        [self incrementWord:word category:category];
        self.wordCount += 1;
    }
    [self incrementCategory:category];
    self.trainingCount += 1;
}

- (NSString *)classify:(NSString *)text
{
    return [self classifyTokens:[self.tokenizer tokenizeWordsInText:text]];
}

- (NSString *)classifyTokens:(NSArray *)tokens
{
    // Compute argmax_cat [log(P(C=cat)) + sum_token(log(P(W=token|C=cat)))]
    float maxScore = NSIntegerMin;
    NSString *bestCategory;
    for (NSString *category in [self.categoryOccurences allKeys]) {
        float currentCategoryScore = 0;
        float pCategory = [self pCategory:category]; // P(C=cat)
        currentCategoryScore += log(pCategory); // log(P(C=cat))
        for (NSString *token in tokens) { // sum_token
            // P(W=token|C=cat) = P(C=cat|W=token) * P(W=token) / P(C=token) [Bayes Theorem]
            float pWordGivenCategory = [self pCategory:category givenWord:token] * [self pWord:token] / pCategory;
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

- (void)incrementWord:(NSString *)word category:(NSString *)category;
{
    if (!self.wordOccurences[word]) {
        self.wordOccurences[word] = [NSMutableDictionary new];
    }
    if (!self.wordOccurences[word][category]) {
        self.wordOccurences[word][category] = @0;
    }
    NSUInteger wordCategoryCount = [self.wordOccurences[word][category] integerValue];
    self.wordOccurences[word][category] = @(wordCategoryCount + 1);
}

- (void)incrementCategory:(NSString *)category
{
    if (!self.categoryOccurences[category]) {
        self.categoryOccurences[category] = @0;
    }
    NSUInteger categoryCount = [self.categoryOccurences[category] integerValue];
    self.categoryOccurences[category] = @(categoryCount + 1);
}


#pragma mark - Probabilities

/**
 Returns P(C=category|W=word).
 @param category The category
 @param word The word
 @return P(C=category|W=word)
 */
- (float)pCategory:(NSString *)category givenWord:(NSString *)word
{
    if (!self.wordOccurences[word]) {
        return kParsimmonNaiveBayesClassifierMinValue;
    }
    if (!self.wordOccurences[word][category]) {
        return kParsimmonNaiveBayesClassifierMinValue;
    }
    return ([self.wordOccurences[word][category] floatValue]) / [self totalOccurencesOfWord:word];
}

/**
 Returns P(W=word).
 @param word The word
 @return P(W=word)
 */
- (float)pWord:(NSString *)word
{
    float pWord = [self totalOccurencesOfWord:word] / self.wordCount;
    return MAX(pWord, kParsimmonNaiveBayesClassifierMinValue);
}

/**
 Return P(C=category).
 @param category The category.
 @return P(C=category)
 */
- (float)pCategory:(NSString *)category
{
    return [self totalOccurencesOfCategory:category] / self.trainingCount;
}


#pragma mark - Counting

- (float)totalOccurencesOfWord:(NSString *)word
{
    if (!self.wordOccurences[word]) {
        return 0;
    }
    float totalOccurencesOfWord = 0;
    for (NSString *category in self.wordOccurences[word]) {
        totalOccurencesOfWord += [self.wordOccurences[word][category] floatValue];
    }
    return totalOccurencesOfWord;
}

- (float)totalOccurencesOfCategory:(NSString *)category
{
    if (!self.categoryOccurences[category]) {
        return 0;
    }
    return [self.categoryOccurences[category] floatValue];
}


#pragma mark - Helpers

- (NSArray *)removeDuplicates:(NSArray *)array
{
    NSSet *set = [NSSet setWithArray:array];
    return [set allObjects];
}


#pragma mark - Properties

- (NSMutableDictionary *)wordOccurences
{
    if (!_wordOccurences) {
        _wordOccurences = [NSMutableDictionary new];
    }
    return _wordOccurences;
}

- (NSMutableDictionary *)categoryOccurences
{
    if (!_categoryOccurences) {
        _categoryOccurences = [NSMutableDictionary new];
    }
    return _categoryOccurences;
}

@end
