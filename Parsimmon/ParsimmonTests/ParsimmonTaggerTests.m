//
//  ParsimmonTaggedTokenTests.m
//  Parsimmon
//
//  Created by Hector Zarate on 10/18/13.
//
//

#import <XCTest/XCTest.h>
#import "ParsimmonTaggedToken.h"
#import "ParsimmonTagger.h"

@interface ParsimmonTaggerTests : XCTestCase

@end

@implementation ParsimmonTaggerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

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
