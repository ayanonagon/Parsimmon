//
//  NaiveBayesClassifier.swift
//  Parsimmon
//
//  Created by Jordan Kay on 2/18/15.
//
//

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

public class NaiveBayesClassifier {
    public typealias Word = String
    public typealias Category = String

    private let tokenizer: Tokenizer

    private var categoryOccurrences: [Category: Int] = [:]
    private var wordOccurrences: [Word: [Category: Int]] = [:]
    private var trainingCount = 0
    private var wordCount = 0

    public init(tokenizer: Tokenizer = Tokenizer()) {
        self.tokenizer = tokenizer
    }

    // MARK: - Training

    /**
     Trains the classifier with text and its category.
     @param text The text
     @param category The category of the text
    */
    public func trainWithText(text: String, category: Category) {
        let tokens = tokenizer.tokenize(text)
        trainWithTokens(tokens, category: category)
    }

    /**
     Trains the classifier with tokenized text and its category.
     This is useful if you wish to use your own tokenization method.
     @param tokens The tokenized text
     @param category The category of the text
    */
    public func trainWithTokens(tokens: [Word], category: Category) {
        let words = Set(tokens)
        for word in words {
            incrementWord(word, category: category)
        }
        incrementCategory(category)
        trainingCount++
    }

    // MARK: - Classifying

    /**
     Classifies the given text based on its training data.
     @param text The text to classify
     @return The category classification
    */
    public func classify(text: String) -> Category? {
        let tokens = tokenizer.tokenize(text)
        return classifyTokens(tokens)
    }

    /**
     Classifies the given tokenized text based on its training data.
     @param text The tokenized text to classify
     @return The category classification if one was found, or nil if one wasn’t
    */
    public func classifyTokens(tokens: [Word]) -> Category? {
        // Compute argmax_cat [log(P(C=cat)) + sum_token(log(P(W=token|C=cat)))]
        return argmax(map(categoryOccurrences) { (category, count) -> (Category, Double) in
            let pCategory = P(category)
            let score = tokens.reduce(log(pCategory)) { [wordCount] (total, token) in
                total + log((self.P(category, token) + smoothingParameter) / (pCategory + smoothingParameter + Double(wordCount)))
            }
            return (category, score)
        })
    }

    // MARK: - Probabilites

    private func P(category: Category, _ word: Word) -> Double {
        if let occurrences = wordOccurrences[word] {
            let count = occurrences[category] ?? 0
            return Double(count) / Double(trainingCount)
        }
        return 0.0
    }

    private func P(category: Category) -> Double {
        return Double(totalOccurrencesOfCategory(category)) / Double(trainingCount)
    }

    // MARK: - Counting

    private func incrementWord(word: Word, category: Category) {
        if wordOccurrences[word] == nil {
            wordCount++
            wordOccurrences[word] = [:]
        }

        let count = wordOccurrences[word]?[category] ?? 0
        wordOccurrences[word]?[category] = count + 1
    }

    private func incrementCategory(category: Category) {
        categoryOccurrences[category] = totalOccurrencesOfCategory(category) + 1
    }

    private func totalOccurrencesOfWord(word: Word) -> Int {
        if let occurrences = wordOccurrences[word] {
            return Array(occurrences.values).reduce(0, combine: +)
        }
        return 0
    }

    private func totalOccurrencesOfCategory(category: Category) -> Int {
        return categoryOccurrences[category] ?? 0
    }
}
