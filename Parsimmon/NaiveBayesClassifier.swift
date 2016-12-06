// NaiveBayesClassifier.swift
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

/**
## Sample usage

let NaiveBayesClassifier classifier = NaiveBayesClassifier()

Train the classifier with some ham examples.

classifier.trainWithText("nom nom ham", category: "ham")
classifier.trainWithText("make sure to get the ham", category: "ham")
classifier.trainWithText("please put the eggs in the fridge", category: "ham")

Train the classifier with some spam examples.

classifier.trainWithText("spammy spam spam", category: "spam")
classifier.trainWithText("what does the fox say?", category: "spam")
classifier.trainWithText("and fish go blub", category: "spam")

Classify some new text. Is it ham or spam? In practice, you'd want to train with more examples first.

let firstExample = "use the eggs in the fridge."
let secondExample = "what does the fish say?"
println("'\(firstExample)' => \(classifier.classify(firstExample)")
println("'\(secondExample)' => \(classifier.classify(secondExample)")

Output:

'use the eggs in the fridge.' => ham
'what does the fish say?' => spam

*/

import Foundation

private let smoothingParameter = 1.0

open class NaiveBayesClassifier {
    public typealias Word = String
    public typealias Category = String

    fileprivate let tokenizer: Tokenizer

    fileprivate var categoryOccurrences: [Category: Int] = [:]
    fileprivate var wordOccurrences: [Word: [Category: Int]] = [:]
    fileprivate var trainingCount = 0
    fileprivate var wordCount = 0

    public init() {
        self.tokenizer = Tokenizer()
    }

    public init(tokenizer: Tokenizer) {
        self.tokenizer = tokenizer
    }

    // MARK: - Training

    /**
        Trains the classifier with text and its category.

        @param text The text
        @param category The category of the text
    */
    open func trainWithText(_ text: String, category: Category) {
        let tokens = tokenizer.tokenize(text)
        trainWithTokens(tokens, category: category)
    }

    /**
        Trains the classifier with tokenized text and its category.
        This is useful if you wish to use your own tokenization method.

        @param tokens The tokenized text
        @param category The category of the text
    */
    open func trainWithTokens(_ tokens: [Word], category: Category) {
        let words = Set(tokens)
        for word in words {
            incrementWord(word, category: category)
        }
        incrementCategory(category)
        trainingCount += 1
    }

    // MARK: - Classifying

    /**
        Classifies the given text based on its training data.

        @param text The text to classify
        @return The category classification
    */
    open func classify(_ text: String) -> Category? {
        let tokens = tokenizer.tokenize(text)
        return classifyTokens(tokens)
    }

    /**
        Classifies the given tokenized text based on its training data.

        @param text The tokenized text to classify
        @return The category classification if one was found, or nil if one wasn’t
    */
    open func classifyTokens(_ tokens: [Word]) -> Category? {
        // Compute argmax_cat [log(P(C=cat)) + sum_token(log(P(W=token|C=cat)))]
        return argmax(categoryOccurrences.map { (category, count) -> (Category, Double) in
            let pCategory = self.P(category)
            let score = tokens.reduce(log(pCategory)) { (total, token) in
                total + log((self.P(category, token) + smoothingParameter) / (pCategory + smoothingParameter + Double(self.wordCount)))
            }
            return (category, score)
        })
    }

    // MARK: - Probabilites

    fileprivate func P(_ category: Category, _ word: Word) -> Double {
        if let occurrences = wordOccurrences[word] {
            let count = occurrences[category] ?? 0
            return Double(count) / Double(trainingCount)
        }
        return 0.0
    }

    fileprivate func P(_ category: Category) -> Double {
        return Double(totalOccurrencesOfCategory(category)) / Double(trainingCount)
    }

    // MARK: - Counting

    fileprivate func incrementWord(_ word: Word, category: Category) {
        if wordOccurrences[word] == nil {
            wordCount += 1
            wordOccurrences[word] = [:]
        }

        let count = wordOccurrences[word]?[category] ?? 0
        wordOccurrences[word]?[category] = count + 1
    }

    fileprivate func incrementCategory(_ category: Category) {
        categoryOccurrences[category] = totalOccurrencesOfCategory(category) + 1
    }

    fileprivate func totalOccurrencesOfWord(_ word: Word) -> Int {
        if let occurrences = wordOccurrences[word] {
            return Array(occurrences.values).reduce(0, +)
        }
        return 0
    }

    fileprivate func totalOccurrencesOfCategory(_ category: Category) -> Int {
        return categoryOccurrences[category] ?? 0
    }
}
