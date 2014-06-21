// ParsimmonTaggerTests.m
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
#import "ParsimmonTaggedToken.h"
#import "ParsimmonTagger.h"

@interface ParsimmonTaggerTests : XCTestCase
@end

@implementation ParsimmonTaggerTests

- (void)testTagWordsInText
{
    NSArray *expectedTaggedTokens = @[[[ParsimmonTaggedToken alloc] initWithToken:@"The" tag:@"Determiner"],
                                      [[ParsimmonTaggedToken alloc] initWithToken:@"quick" tag:@"Adjective"],
                                      [[ParsimmonTaggedToken alloc] initWithToken:@"brown" tag:@"Adjective"],
                                      [[ParsimmonTaggedToken alloc] initWithToken:@"fox" tag:@"Noun"],
                                      [[ParsimmonTaggedToken alloc] initWithToken:@"jumps" tag:@"Noun"],
                                      [[ParsimmonTaggedToken alloc] initWithToken:@"over" tag:@"Preposition"],
                                      [[ParsimmonTaggedToken alloc] initWithToken:@"the" tag:@"Determiner"],
                                      [[ParsimmonTaggedToken alloc] initWithToken:@"lazy" tag:@"Adjective"],
                                      [[ParsimmonTaggedToken alloc] initWithToken:@"dog" tag:@"Noun"]];
    
    NSString *testStringOne = @"The quick brown fox jumps over the lazy dog";
    
    ParsimmonTagger *tagger = [[ParsimmonTagger alloc] init];
    
    NSArray *taggedTokens = [tagger tagWordsInText:testStringOne];
    
    XCTAssertEqualObjects(taggedTokens, expectedTaggedTokens, @"Failed to tagged words in text");
}

@end
