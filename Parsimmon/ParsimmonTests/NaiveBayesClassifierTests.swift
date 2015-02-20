//
//  NaiveBayesClassifierTests.swift
//  Parsimmon
//
//  Created by Jordan Kay on 2/18/15.
//
//

import XCTest
import Parsimmon

class NaiveBayesClassifierTests : XCTestCase {
    func testBasicExample() {
        let classifier = NaiveBayesClassifier()

        // Train the classifier with some ham examples.
        classifier.trainWithText("nom nom ham", category: "ham")
        classifier.trainWithText("make sure to get the ham", category: "ham")
        classifier.trainWithText("please put the eggs in the fridge", category: "ham")

        // Train the classifier with some spam examples.
        classifier.trainWithText("spammy spam spam", category: "spam")
        classifier.trainWithText("what does the fox say?", category: "spam")
        classifier.trainWithText("and fish go blub", category: "spam")

        // Classify some new text. Is it ham or spam?
        // In practice, you'd want to train with more examples first.
        let firstExample = "use the eggs in the fridge."
        let secondExample = "what does the fish say?"

        XCTAssertEqual(classifier.classify(firstExample)!, "ham")
        XCTAssertEqual(classifier.classify(secondExample)!, "spam")
    }
}
