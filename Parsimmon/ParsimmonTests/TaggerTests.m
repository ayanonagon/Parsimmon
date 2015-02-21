//
//  ParsimmonTaggedTokenTests.m
//  Parsimmon
//
//  Created by Hector Zarate on 10/18/13.
//
//

#import <XCTest/XCTest.h>
#import "ParsimmonTests-Swift.h"

@interface TaggerTests : XCTestCase

@end

@implementation TaggerTests

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
    NSArray *expectedTaggedTokens = @[[[TaggedToken alloc] initWithToken:@"The" tag:@"Determiner"],
                                      [[TaggedToken alloc] initWithToken:@"quick" tag:@"Adjective"],
                                      [[TaggedToken alloc] initWithToken:@"brown" tag:@"Adjective"],
                                      [[TaggedToken alloc] initWithToken:@"fox" tag:@"Noun"],
                                      [[TaggedToken alloc] initWithToken:@"jumps" tag:@"Noun"],
                                      [[TaggedToken alloc] initWithToken:@"over" tag:@"Preposition"],
                                      [[TaggedToken alloc] initWithToken:@"the" tag:@"Determiner"],
                                      [[TaggedToken alloc] initWithToken:@"lazy" tag:@"Adjective"],
                                      [[TaggedToken alloc] initWithToken:@"dog" tag:@"Noun"]];
    
    NSString *testStringOne = @"The quick brown fox jumps over the lazy dog";
    
    Tagger *tagger = [[Tagger alloc] init];
    
    NSArray *taggedTokens = [tagger tagWordsInText:testStringOne];
    
    XCTAssertEqualObjects(taggedTokens, expectedTaggedTokens, @"Failed to tagged words in text");
}

@end
