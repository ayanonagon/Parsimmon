// Enumerator.swift
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

typealias Pair = (String, String)

protocol Analyzer {
    var seed: Seed { get }
    var scheme: String { get }
}

internal func analyze(_ analyzer: Analyzer, text: String, options: NSLinguisticTagger.Options?) -> [Pair] {
    var pairs: [Pair] = []

    let range = NSRange(location: 0, length: text.characters.count)
    let options = options ?? analyzer.seed.linguisticTaggerOptions
    let tagger = analyzer.seed.linguisticTaggerWithOptions(options)

    tagger.string = text
    tagger.setOrthography(analyzer.seed.orthography, range: range)
    tagger.enumerateTags(in: range, scheme: analyzer.scheme, options: options) { (tag: String?, tokenRange, range, stop) in
        if let tag = tag {
            let token = (text as NSString).substring(with: tokenRange)
            let pair = (token, tag)
            pairs.append(pair)
        }
    }
    return pairs
}
