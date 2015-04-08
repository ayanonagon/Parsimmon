// ClassifierViewController.swift
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

import Foundation
import UIKit
import Parsimmon

class ClassifierViewController: UIViewController {
    @IBOutlet private weak var messageTextField: UITextField!
    @IBOutlet private weak var resultLabel: UILabel!
    
    private lazy var classifier = NaiveBayesClassifier()

    @IBAction private func spamOrHamAction(sender: UIButton) {
        let category = classifier.classify(messageTextField.text)
        resultLabel.text = category
    }

    private func train() {
        let hams = [
            "Hi, how was work?",
            "What's the weather like tomorrow?",
            "Please take the dogs out for a walk."
        ]
        let spams = [
            "Get your free copy of AOL today!",
            "Get a free pink iPhone by clicking HERE",
            "Spam spam spam spam."
        ]
        feedHams(hams)
        feedSpams(spams)
    }

    private func feedHams(hams: [String]) {
        for ham in hams {
            classifier.trainWithText(ham, category: "ham")
        }
    }

    private func feedSpams(spams: [String]) {
        for spam in spams {
            classifier.trainWithText(spam, category: "spam")
        }
    }
}

extension ClassifierViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        train()
    }
}
