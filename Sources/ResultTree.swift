//  MIT License
//
//  Copyright (c) 2017 Lucas Stomberg
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

//
// MARK: ResultTree
//

public struct ResultTree {
    let activities: [Activity]

    public struct Activity {
        let name: String
        let sections: [Section]

        public struct Section {
            let name: String
            let runs: [Run]

            public struct Run {
                let name: String
                let partitions: [Partition]

                public struct Partition {
                    let name: String
                    let times: [TimeInterval]
                }
            }
        }
    }
}

//
// MARK: ResultTree creation APIs
//

extension ResultTree {
    init(from results: [Result]) {
        let grouped = Dictionary(grouping: results) { $0.configuration.activity.name }
        self.activities = grouped.map { ResultTree.Activity(name: $0.key, results: $0.value) }
    }
}

extension ResultTree.Activity {
    init(name: String, results: [Result]) {
        self.name = name
        let grouped = Dictionary(grouping: results) { $0.configuration.activity.section }
        self.sections = grouped.map { ResultTree.Activity.Section(name: $0.key, results: $0.value) }
    }
}

extension ResultTree.Activity.Section {
    init(name: String, results: [Result]) {
        self.name = name
        let grouped = Dictionary(grouping: results) { $0.configuration.name }
        self.runs = grouped.map { ResultTree.Activity.Section.Run(name: $0.key, results: $0.value) }
    }
}

extension ResultTree.Activity.Section.Run {
    init(name: String, results: [Result]) {
        self.name = name
        let grouped = Dictionary(grouping: results) { $0.additionalClassification }
        self.partitions = grouped.map { ResultTree.Activity.Section.Run.Partition(name: $0.key, results: $0.value) }
    }
}

extension ResultTree.Activity.Section.Run.Partition {
    init(name: String, results: [Result]) {
        self.name = name
        self.times = results.map { $0.duration }
    }
}


//
// MARK: ResultTree printing
//

extension ResultTree.Activity.Section.Run.Partition: CustomStringConvertible {
    public var description: String {
        let count = times.count
        let average = times.reduce(0, +) / Double(count)
        let max = times.max() ?? 0
        let min = times.min() ?? 0

        return [
            "Partition: \(self.name)",
            "Task count: \(count)",
            String(format:"Maximum: %.2f", max),
            String(format:"Average: %.2f", average),
            String(format:"Minimum: %.2f", min),
        ].joined(separator: "\n  ")
    }
}

extension ResultTree.Activity.Section.Run: CustomStringConvertible {
    public var description: String {
        let partitionText = partitions.map { $0.description.replacingOccurrences(of: "\n", with: "\n  ") }.joined(separator: "\n  ")

        // for a single partition, compact output by beginning text on same line as Run name
        let lineSeparator = partitions.count == 1 ? "  " : "\n  "
        return [
            "Run: \(self.name)",
            partitionText
        ].joined(separator: lineSeparator)
    }
}

extension ResultTree.Activity.Section: CustomStringConvertible {
    public var description: String {
        let runText = runs.map { $0.description.replacingOccurrences(of: "\n", with: "\n  ") }.joined(separator: "\n  ")
        return [
            "Section: \(self.name)",
            runText
        ].joined(separator: "\n  ")
    }
}

extension ResultTree.Activity: CustomStringConvertible {
    public var description: String {
        let sectionText = sections.map { $0.description.replacingOccurrences(of: "\n", with: "\n  ") }.joined(separator: "\n  ")

        // for a single section, compact output by beginning text on same line as Activity name
        let lineSeparator = sections.count == 1 ? "  " : "\n  "
        return [
            "Activity: \(self.name)",
            sectionText
        ].joined(separator: lineSeparator)
    }
}

extension ResultTree: CustomStringConvertible {
    public var description: String {
        let activityText = activities.map { $0.description }.joined(separator: "\n")
        return [
            "Report",
            "------",
            activityText
        ].joined(separator: "\n")
    }
}
