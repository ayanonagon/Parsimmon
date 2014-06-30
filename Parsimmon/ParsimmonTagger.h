// ParsimmonTagger.h
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

#import <Foundation/Foundation.h>
#import "ParsimmonSeed.h"

/**
 ## Sample usage

    ParsimmonTagger *tagger = [[ParsimmonTagger alloc] init];
    NSArray *taggedTokens = [tagger tagWordsInText:@"The quick brown fox jumps over the lazy dog"];
    NSLog(@"%@", taggedTokens);

 Output:

    (
    "('The', Determiner)",
    "('quick', Adjective)",
    "('brown', Adjective)",
    "('fox', Noun)",
    "('jumps', Noun)",
    "('over', Preposition)",
    "('the', Determiner)",
    "('lazy', Adjective)",
    "('dog', Noun)"
    )

 */
@interface ParsimmonTagger : ParsimmonSeed

/**
 Returns the tagged tokens for the input text, omitting any whitespace, punctuation, and other symbols.
 @param text The text to tag
 @return The tagged tokens
 */
- (NSArray *)tagWordsInText:(NSString *)text;

/**
 Returns the tagged tokens for the input text using the specified linguistic tagger options.
 @param text Text to tag
 @param options Linguistic tagger options
 @return The tagged tokens
 */
- (NSArray *)tagText:(NSString *)text options:(NSLinguisticTaggerOptions)options;

@end
