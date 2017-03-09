// ParsimmonDecisionTreeTests.swift
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

class DecisionTreeTests : XCTestCase {
    func testXOR() {
        let decisionTree = DecisionTree(featureNames: ("A", "B"), classificationNames: ("zero", "one"))

        decisionTree.addSample(datum: Datum(featureValues: (1, 1), classification: 0))
        decisionTree.addSample(datum: Datum(featureValues: (0, 0), classification: 0))
        decisionTree.addSample(datum: Datum(featureValues: (1, 0), classification: 1))
        decisionTree.addSample(datum: Datum(featureValues: (0, 1), classification: 1))
        decisionTree.build()

        XCTAssertEqual(0, decisionTree.root!.leftChild!.leftChild!.value, "Failed 0 XOR 0 case.")
        XCTAssertEqual(1, decisionTree.root!.leftChild!.rightChild!.value, "Failed 0 XOR 1 case.")
        XCTAssertEqual(1, decisionTree.root!.rightChild!.leftChild!.value, "Failed 1 XOR 0 case.")
        XCTAssertEqual(0, decisionTree.root!.rightChild!.rightChild!.value, "Failed 1 XOR 1 case.")
        
        let zeroZero = decisionTree.classify(sample: [0, 0])
        XCTAssertEqual("zero", zeroZero!, "Failed 0 XOR 0 case classification.")
        
        let zeroOne = decisionTree.classify(sample: [0, 1])
        XCTAssertEqual("one", zeroOne!, "Failed 0 XOR 1 case classification.")
        
        let oneZero = decisionTree.classify(sample: [1, 0])
        XCTAssertEqual("one", oneZero!, "Failed 1 XOR 0 case classification.")
        
        let oneOne = decisionTree.classify(sample: [1, 1])
        XCTAssertEqual("zero", oneOne!, "Failed 1 XOR 1 case classification.")
    }
}
