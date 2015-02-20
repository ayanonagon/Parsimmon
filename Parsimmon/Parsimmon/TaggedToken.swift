//
//  TaggedToken.swift
//  Parsimmon
//
//  Created by Jordan Kay on 2/19/15.
//
//

import Foundation

class TaggedToken: NSObject, Equatable {
    let token: String
    let tag: String

    init(token: String, tag: String) {
        self.token = token
        self.tag = tag
    }

    override var hash: Int {
        return token.hash ^ tag.hash
    }

    override func isEqual(object: AnyObject?) -> Bool {
        if let taggedToken = object as? TaggedToken {
            return isEqualToTaggedToken(taggedToken)
        }
        return false
    }

    private func isEqualToTaggedToken(taggedToken: TaggedToken) -> Bool {
        return token == taggedToken.token && tag == taggedToken.tag
    }
}

extension TaggedToken: Printable {
    override var description: String {
        return "('\(token)' \(tag))"
    }
}

func ==(lhs: TaggedToken, rhs: TaggedToken) -> Bool {
    return lhs.token == rhs.token && lhs.tag == rhs.tag
}
