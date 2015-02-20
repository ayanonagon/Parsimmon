//
//  Enumerator.swift
//  Parsimmon
//
//  Created by Jordan Kay on 2/19/15.
//
//

import Foundation

typealias Pair = (String, String)

protocol Analyzer {
    var seed: Seed { get }
    var scheme: String { get }
}

internal func analyze(analyzer: Analyzer, text: String, options: NSLinguisticTaggerOptions?) -> [Pair] {
    var pairs: [Pair] = []

    let range = NSRange(location: 0, length: count(text))
    let options = options ?? analyzer.seed.linguisticTaggerOptions
    let tagger = analyzer.seed.linguisticTaggerWithOptions(options)

    tagger.string = text
    tagger.enumerateTagsInRange(range, scheme: analyzer.scheme, options: options) { (tag: String?, tokenRange, range, stop) in
        if let tag = tag {
            let token = (text as NSString).substringWithRange(tokenRange)
            let pair = (token, tag)
            pairs.append(pair)
        }
    }
    return pairs
}
