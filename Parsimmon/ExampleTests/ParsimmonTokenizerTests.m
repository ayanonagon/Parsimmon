//
//  ParsimmonTokenizerTests.m
//  Parsimmon
//
//  Created by Hector Zarate on 10/15/13.
//
//

#import <XCTest/XCTest.h>
#import "ParsimmonTokenizer.h"


@interface ParsimmonTokenizerTests : XCTestCase

@end

@implementation ParsimmonTokenizerTests

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

- (void)testTokenizeWords
{
    NSArray *expectedTokens = @[@"I",
                                @"the",
                                @"quick",
                                @"brown",
                                @"fox",
                                @"jumped",
                                @"over",
                                @"the",
                                @"lazy",
                                @"dog"];
    
    NSString *testStringOne = @"I, the quick  brown fox jumped over the lazy dog...";
    
    ParsimmonTokenizer *tokenizer = [[ParsimmonTokenizer alloc] init];
    
    NSArray *tokens = [tokenizer tokenizeWordsInText:testStringOne];
    
    XCTAssertEqualObjects(tokens, expectedTokens, @"Failed to tokenize words in text");
    
    
}

@end
