//
//  Seed.swift
//  Parsimmon
//
//  Created by Jordan Kay on 2/19/15.
//
//

import Foundation

struct Seed {
    typealias Language = String

    private let language: Language = "en"
    let linguisticTaggerOptions: NSLinguisticTaggerOptions = .OmitWhitespace | .OmitPunctuation | .OmitOther

    func linguisticTaggerWithOptions(options: NSLinguisticTaggerOptions) -> NSLinguisticTagger {
        let tagSchemes = NSLinguisticTagger.availableTagSchemesForLanguage(self.language)
        return NSLinguisticTagger(tagSchemes: tagSchemes, options: Int(options.rawValue))
    }
}
