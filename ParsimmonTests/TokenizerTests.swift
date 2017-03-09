//  TokenizerTests.swift
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

import XCTest
import Parsimmon

class TokenizerTests : XCTestCase {

	func testTokenizeWords() {
		let expectedTokens = ["I",
			"the",
			"quick",
			"brown",
			"fox",
			"jumped",
			"over",
			"the",
			"lazy",
			"dog"]

		let testStringOne = "I, the quick  brown fox jumped over the lazy dog..."

		let tokenizer = Tokenizer();
		let tokens = tokenizer.tokenize(text: testStringOne);

		XCTAssertEqual(tokens, expectedTokens, "Failed to tokenize words in text")
	}

	func testTokenizeAllWhitespace() {
		let tokenizer = Tokenizer();
		let tokens = tokenizer.tokenize(text: "               ");
		XCTAssertEqual(tokens, [], "Failed to tokenize all whitespace")
	}
}
