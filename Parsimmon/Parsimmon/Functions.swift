//
//  Functions.swift
//  Parsimmon
//
//  Created by Jordan Kay on 2/18/15.
//
//

import Foundation

func argmax<T, U: Comparable>(elements: [(T, U)]) -> T? {
    if let start = elements.first {
        return elements.reduce(start) { $0.1 > $1.1 ? $0 : $1 }.0
    }
    return nil
}
