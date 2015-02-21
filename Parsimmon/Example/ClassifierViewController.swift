//
//  ClassifierViewController.swift
//  Parsimmon
//
//  Created by Ayaka Nonaka on 10/13/13.
//
//

import Foundation
import UIKit

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
