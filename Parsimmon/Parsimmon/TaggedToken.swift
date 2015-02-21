//
//  TaggedToken.swift
//  Parsimmon
//
//  Created by Jordan Kay on 2/19/15.
//
//

import Foundation

struct TaggedToken: Equatable {
    let token: String
    let tag: String
}

extension TaggedToken: Printable {
    var description: String {
        return "('\(token)' \(tag))"
    }
}

func ==(lhs: TaggedToken, rhs: TaggedToken) -> Bool {
    return lhs.token == rhs.token && lhs.tag == rhs.tag
}
