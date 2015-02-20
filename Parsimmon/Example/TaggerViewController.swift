//
//  ClassifierViewController.swift
//  Parsimmon
//
//  Created by Ayaka Nonaka on 10/10/13.
//
//

import Foundation
import UIKit

class TaggerViewController: UIViewController {
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var outputTextview: UITextView!
    
    private lazy var tagger = Tagger()
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction private func parsimmonAction(sender: UIButton) {
        let taggedTokens = tagger.tagWordsInText(inputTextField.text)
        outputTextview.text = "\(taggedTokens)"
        dismissKeyboard()
    }
}

extension TaggerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
}
