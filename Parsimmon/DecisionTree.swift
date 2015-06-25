// DecisionTree.swift
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

public struct Datum {
    public let featureValues: (Bit, Bit)
    public let classification: Bit
    
    public init(featureValues: (Bit, Bit), classification: Bit) {
        self.featureValues = featureValues
        self.classification = classification
    }
    
    public func featureValueAtPosition(position: Bit) -> Bit {
        if position.rawValue == 0 {
            return self.featureValues.0
        } else {
            return self.featureValues.1
        }
    }
}

public class Node<T> {
    public var leftChild: Node<T>?
    public var rightChild: Node<T>?
    public var value: T
    
    init(value: T) {
        self.value = value
    }
}

public class DecisionTree {
    public var root: Node<Bit>?
    public var maxDepth: Int = 5
    private let featureNames: (String, String)
    private let classificationNames: (String, String)
    private var data = [Datum]()
    
    public init(featureNames: (String, String), classificationNames: (String, String)) {
        self.featureNames = featureNames
        self.classificationNames = classificationNames
    }

    /**
        Adds a data point to the decision tree.

        @param datum A data point
    */
    public func addSample(datum: Datum) {
        self.data.append(datum)
    }

    /**
        Builds the decision tree based on the data it has.
    */
    public func build() {
        let features = [ Bit.Zero, Bit.One ]
        self.root = self.decisionTree(self.data, remainingFeatures: features, maxDepth: self.maxDepth)
    }
    
    public func classify(sample: [Int]) -> String? {
        var node = self.root
        while (node != nil) {
            let unwrappedNode = node!
            if let _ = unwrappedNode.leftChild {
                let pathToTake = sample[unwrappedNode.value.rawValue]
                if pathToTake == 0 {
                    node = unwrappedNode.leftChild
                } else {
                    node = unwrappedNode.rightChild
                }
            } else if unwrappedNode.value.rawValue == 0 {
                return self.classificationNames.0
            } else if unwrappedNode.value.rawValue == 1 {
                return self.classificationNames.1
            }
        }
        return nil
    }
    
    private func decisionTree(data: [Datum], remainingFeatures: [Bit], maxDepth: Int) -> Node<Bit> {
        let tree = Node<Bit>(value: Bit.Zero)
        if data.first == nil {
            return tree
        }
        
        // Check for the two base cases.
        let firstDatum = data.first!
        let firstDatumFeatureValues = [ firstDatum.featureValues.0, firstDatum.featureValues.1 ]
        let firstDatumClassification = firstDatum.classification
        
        var allSameClassification = true
        var allSameFeatureValues = true
        var count = 0
        
        for datum in data {
            let datumClassification = datum.classification
            if firstDatumClassification != datumClassification {
                allSameClassification = false
            }
            let datumFeatureValues = [ datum.featureValues.0, datum.featureValues.1 ]
            if firstDatumFeatureValues != datumFeatureValues {
                allSameFeatureValues = false
            }
            count += datumClassification.rawValue
        }
        
        if allSameClassification == true {
            tree.value = firstDatum.classification
        } else if allSameFeatureValues == true || maxDepth == 0 {
            tree.value = count > (data.count / 2) ? Bit.One : Bit.Zero
        } else {
            // Find the best feature to split on and recurse.
            var maxInformationGain = -Float.infinity
            var bestFeature = Bit.Zero
            for feature in remainingFeatures {
                let informationGain = self.informationGain(feature, data: data)
                if informationGain >= maxInformationGain {
                    maxInformationGain = informationGain
                    bestFeature = feature
                }
            }
            let splitData = self.splitData(data, onFeature: bestFeature)
            var newRemainingFeatures = remainingFeatures
            if let bestFeatureIndex = newRemainingFeatures.indexOf(bestFeature) {
                newRemainingFeatures.removeAtIndex(bestFeatureIndex)
                tree.leftChild = self.decisionTree(splitData.0, remainingFeatures: newRemainingFeatures, maxDepth: maxDepth - 1)
                tree.rightChild = self.decisionTree(splitData.1, remainingFeatures: newRemainingFeatures, maxDepth: maxDepth - 1)
                tree.value = bestFeature
            }
        }
        
        return tree
    }
    
    private func splitData(data: [Datum], onFeature: Bit) -> ([Datum], [Datum]) {
        var first = [Datum]()
        var second = [Datum]()
        for datum in data {
            if datum.featureValueAtPosition(onFeature).rawValue == 0 {
                first.append(datum)
            } else {
                second.append(datum)
            }
        }
        return (first, second)
    }
    
    // MARK: Entropy
    
    private func informationGain(feature: Bit, data: [Datum]) -> Float {
        return self.HY(data) - self.HY(data, X: feature)
    }
    
    private func HY(data: [Datum]) -> Float {
        let pY0: Float = self.pY(data, Y: 0)
        let pY1 = 1.0 - pY0
        return -1.0 * (pY0 * log2(pY0) + pY1 * log2(pY1))
    }
    
    private func HY(data: [Datum], X: Bit) -> Float {
        var result = Float(0.0)
        for x in [0, 1] {
            for y in [0, 1] {
                result -= self.pX(data, X: x, Y: y, feature: X) * log2(self.pY(data, Y: y, X: x, feature: X))
            }
        }
        return result
    }
    
    private func pY(data: [Datum], Y: Int) -> Float {
        var count = 0
        for datum in data {
            if datum.classification.rawValue == Y {
                count++
            }
        }
        return Float(count) / Float(data.count)
    }
    
    private func pY(data: [Datum], Y: Int, X: Int, feature: Bit) -> Float {
        var yCount = 0
        var xCount = 0
        for datum in data {
            if datum.featureValueAtPosition(feature).rawValue == X {
                xCount++
                if datum.classification.rawValue == Y {
                    yCount++
                }
            }
        }
        return Float(yCount) / Float(xCount)
    }
    
    private func pX(data: [Datum], X: Int, Y: Int, feature: Bit) -> Float {
        var count = 0
        for datum in data {
            if datum.classification.rawValue == Y && datum.featureValueAtPosition(feature).rawValue == X {
                count++
            }
        }
        return Float(count) / Float(data.count)
    }
}
