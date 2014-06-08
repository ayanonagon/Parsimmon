// ParsimmonTokenizer.swift
//
// Copyright (c) 2014 Ayaka Nonaka
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

// Unfortunate extension that is needed to convert an NSRange to Range
// This also deals with UTF16 encoding
extension String.Index {
	init(utf16Offset: Int, string: String) {
		self = String.Index(String.UnicodeScalarView.IndexType(utf16Offset, string.core)) // Note: string.core is a private API...
	}
}

class ParsimmonTokenizer : ParsimmonSeed {

	func tokenize(text: String) -> String[] {
		return self.tokenize(text, options:self.defaultLinguisticTaggerOptions())
	}

	func tokenize(text: String, options: NSLinguisticTaggerOptions) -> String[] {
		var tokens = String[]()
		let tagger = self.linguisticTaggerWithOptions(options)
		tagger.string = text
		tagger.enumerateTagsInRange(NSRange(location:0, length:countElements(text)),
			scheme:NSLinguisticTagSchemeNameTypeOrLexicalClass,
			options:options) {
				(tag: String!, tokenRange: NSRange, sentenceRange: NSRange, stop: CMutablePointer) -> Void in
				let startIndex = String.Index(utf16Offset:tokenRange.location, string:text)
				let endIndex = String.Index(utf16Offset:tokenRange.location + tokenRange.length, string:text);
				let token = text[startIndex..endIndex]
				tokens.append(token)
		}
		return tokens
	}
}
