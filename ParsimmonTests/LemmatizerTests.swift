//  TokenizerTests.swift
//
// Copyright (c) 2015 Ayaka Nonaka
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

class LemmatizerTests : XCTestCase {
    func testLemmatizeWordsInText() {
        let testString = "Diane, I'm holding in my hand a small box of chocolate bunnies."
        let expectedOutput = [
            "diane",
            "i",
            "hold",
            "in",
            "i",
            "hand",
            "a",
            "small",
            "box",
            "of",
            "chocolate",
            "bunny"
        ]
        
        let lemmatizer = Lemmatizer()
        let lemmatizedTokenStrings = lemmatizer.lemmatizeWordsInText(testString)
        
        XCTAssertEqual(expectedOutput, lemmatizedTokenStrings, "Failed to lematize words in text")
    }
}
