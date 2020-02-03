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
// MARK: Activity
//
/// Defines the functional area running a task
public struct Activity : Codable, Equatable {
    public let name: String
    public let section: String

    public init(name: String, section: String = Activity.NoSection) {
        self.name = name
        self.section = section
    }
}

extension Activity {
    public static let NoSection: String = "(base)"
}

//
// MARK: TaskConfiguration
//
/// basic task definition + additional details
public struct TaskConfiguration : Codable {
    public let name: String
    public let activity: Activity
    public let executionDetails: String?

    public init(name: String, activity: Activity, executionDetails: String? = nil) {
        self.name = name
        self.activity = activity
        self.executionDetails = executionDetails
    }
}


//
// MARK: Task
//
/// Running task
internal struct Task {
    public let configuration: TaskConfiguration
    public let startTime: Date = Date()
}

//
// MARK: Result
//
/// Result of a running task
public struct Result : Codable {
    public let configuration: TaskConfiguration
    public let duration: TimeInterval
    public let additionalClassification: String
}

extension Result {
    public static let NoAdditionalClassification: String = "(base)"
}

//
// MARK: Task -> Result
//
extension Task {

    public func finish(_ classification: String = Result.NoAdditionalClassification) -> Result {
        let duration = Date().timeIntervalSince(self.startTime)
        let result = Result(configuration: self.configuration, duration: duration, additionalClassification: classification)
        return result
    }

}
